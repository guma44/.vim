#!/usr/bin/env python
"""
%HERE%
"""

__date__ = "%DATE%"
__author__ = "%USER%"
__email__ = "%MAIL%"
__license__ = "%LICENSE%"

# imports
import sys
import time
import errno
import logging
from contextlib import contextmanager
from argparse import ArgumentParser, RawTextHelpFormatter


def main(options, logger):
    """Main logic of the script"""
    pass


def parse_options():
    parser = ArgumentParser(
        description=__doc__,
        formatter_class=RawTextHelpFormatter)

    parser.add_argument("-v",
                        "--verbosity",
                        dest="verbosity",
                        choices=('DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL'),
                        default='ERROR',
                        help="Verbosity/Log level. Defaults to ERROR")
    parser.add_argument("-l",
                        "--logfile",
                        dest="logfile",
                        help="Store log to this file.")
    #
    #######################################################################
    # Put you arguments here. For one input and one output file you can
    # use sys.stdin and sys.stdout as a default value and use smart_open
    # function to redirect correctly the streams. In this way you can use
    # pipes and redirections as well as input parameters.
    #######################################################################
    #
    return parser, parser.parse_args()


@contextmanager
def smart_open(filepath, mode='r'):
    """Open file intelligently depending on the source

    :param filepath: can be both path to file or sys.stdin or sys.stdout
    :param mode: mode can be read "r" or write "w". Defaults to "r"
    :yield: context manager for file handle

    """
    if mode == 'r':
        if filepath is not sys.stdin:
            fh = open(filepath, 'r')
        else:
            fh = filepath
        try:
            yield fh
        except IOError as e:
            if fh is not sys.stdin:
                fh.close()
            elif e.errno == errno.EPIPE:
                pass
        finally:
            if fh is not sys.stdin:
                fh.close()
    elif mode == 'w':
        if filepath is not sys.stdout:
            fh = open(filepath, 'w')
        else:
            fh = filepath
        try:
            yield fh
        finally:
            if fh is not sys.stdout:
                fh.close()
    else:
        raise Exception("No mode %s for file" % mode)


if __name__ == '__main__':
    try:
        try:
            parser, options = parse_options()
        except Exception, e:
            parser.print_help()
            sys.exit()
        #
        #######################################################################
        # Set up logging
        #######################################################################
        #
        formatter = logging.Formatter(
            fmt="[%(asctime)s] %(levelname)s - %(message)s",
            datefmt="%d-%b-%Y %H:%M:%S")
        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        logger = logging.getLogger('uniprot_to_json')
        logger.setLevel(logging.getLevelName(options.verbosity))
        logger.addHandler(console_handler)
        if options.logfile is not None:
            logfile_handler = logging.handlers.RotatingFileHandler(
                options.logfile,
                maxBytes=50000,
                backupCount=2)
            logfile_handler.setFormatter(formatter)
            logger.addHandler(logfile_handler)
        #
        #######################################################################
        #
        start_time = time.time()
        start_date = time.strftime("%d-%m-%Y at %H:%M:%S")
        #
        #######################################################################
        # Run main
        #######################################################################
        #
        logger.info("Starting script")
        main(options, logger)
        #
        #######################################################################
        seconds = time.time() - start_time
        minutes, seconds = divmod(seconds, 60)
        hours, minutes = divmod(minutes, 60)
        logger.info(("Successfully finished in {hours} hour(s) {minutes} "
                     "minute(s) and {seconds} second(s)").format(
            hours=int(hours),
            minutes=int(minutes),
            seconds=int(seconds) if seconds > 1.0 else 1
        ))
    except KeyboardInterrupt as e:
        logger.warn(("Interrupted by user after {hours} hour(s) {minutes} "
                     "minute(s) and {seconds} second(s)").format(
            hours=int(hours),
            minutes=int(minutes),
            seconds=int(seconds) if seconds > 1.0 else 1
        ))
        sys.exit(-1)
    except Exception as e:
        logger.exception(str(e))
        raise e
