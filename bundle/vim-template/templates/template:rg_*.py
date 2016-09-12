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
from contextlib import contextmanager
from argparse import ArgumentParser, RawTextHelpFormatter

parser = ArgumentParser(description=__doc__, formatter_class=RawTextHelpFormatter)
parser.add_argument("-v",
                    "--verbose",
                    dest="verbose",
                    action="store_true",
                    default=False,
                    help="Be loud!")


# define colors for the terminal
colors = {"native": '\033[m',
          "red": '\033[0;31m',          # Red
          "green": '\033[0;32m',        # Green
          "yellow": '\033[0;33m',       # Yellow
          "blue": '\033[0;34m',         # Blue
          "purple": '\033[0;35m',       # Purple
          "cyan": '\033[0;36m',         # Cyan
          "white": '\033[0;37m',        # White
          "bred": '\033[1;31m',         # Bold Red
          "bgreen": '\033[1;32m',       # Bold Green
          "byellow": '\033[1;33m',      # Bold Yellow
          "bblue": '\033[1;34m',        # Bold Blue
          "bpurple": '\033[1;35m',      # Bold Purple
          "bcyan": '\033[1;36m',        # Bold Cyan
          "bwhite": '\033[1;37m',       # Bold White
}

# redefine a functions for writing to stdout and stderr to save some writing
syserr = sys.stderr.write
sysout = sys.stdout.write


def main(options):
    """Main logic of the script"""
    pass


def infolog(text, color=colors['bwhite']):
    """Log info"""
    syserr(color + text + colors['native'])


def errorlog(text, color=colors['bred']):
    """Log error"""
    syserr(color + text + colors['native'])


def successlog(text, color=colors['bgreen']):
    """Log success"""
    syserr(color + text + colors['native'])


def warninglog(text, color=colors['byellow']):
    """Log success"""
    syserr(color + text + colors['native'])


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
            options = parser.parse_args()
        except Exception, e:
            parser.print_help()
            sys.exit()
        if options.verbose:
            start_time = time.time()
            start_date = time.strftime("%d-%m-%Y at %H:%M:%S")
            infolog("############## Started script on %s ##############\n" %
                   start_date)
        main(options)
        if options.verbose:
            infolog("### Successfully finished in %i seconds, on %s ###\n" %
                   (time.time() - start_time,
                    time.strftime("%d-%m-%Y at %H:%M:%S")))
    except KeyboardInterrupt:
        errorlog("Interrupted by user after %i seconds!\n" %
               (time.time() - start_time))
        sys.exit(-1)
