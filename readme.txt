Pipeline:
1- Getting the image and apply adaptive binarization to avoid shadows.
2- Getting the largest object in the image (assumed to be Sudoku puzzle).
3- Getting the corners of the Sudoku puzzle
4- Performing Perspective correction.
4- Running OCR to detect numbers.
5- Solve the Sudoku and display output.

Guide:
- you should run this script using MATLAB 2014a (previous versions won't work)
- To start, run function Sudoku.m and give it the Sudoku image path.