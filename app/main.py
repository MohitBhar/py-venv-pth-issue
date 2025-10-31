#!/usr/bin/env python3

from calculator import add

def main():
    num1 = 10
    num2 = 25
    result = add(num1, num2)

    print(f"Sum of {num1} and {num2} is: {result}")

if __name__ == '__main__':
    main()