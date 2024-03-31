# Format of input data

Each line contains a name followed by whitespace and number of votes. If the
name is `seats` then the number in the line is number of seats to distribute.
For example:

    A 10
    B 20
    C 30
    seats 21

corresponds to a case where 21 seats have to be distributed between three
parties A (with 10 votes), B (with 20 votes) and C (with 30 votes).

## Test Example

Running the command line program with input data from

    <path-to-source>/example/input.txt

should produce following output

    ============ QUOTA =============
    name           result  remainder
    A                 185         25
    B                 177        105
    C                 170         50
    D                 162        130
    E                 155         75
    F                 148         20
    rest: 3
    ============ FINAL =============
    name           result  remainder
    A                 185         25
    B                 178        105
    C                 170         50
    D                 163        130
    E                 156         75
    F                 148         20
