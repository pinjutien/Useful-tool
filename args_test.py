import random

import argparse

def main(x, y):
    print(x)
    return y
    


if __name__ == '__main__':
    import sys, os

    parser = argparse.ArgumentParser(description= "test!")

    parser.add_argument('-x1', help = 'say x1')
    parser.add_argument('-x2', help = 'say x2')
    args = parser.parse_args()
    main( args.x1, args.x2)

