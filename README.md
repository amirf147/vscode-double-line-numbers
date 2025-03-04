# Double Line Numbers for VS Code

![Double Line Numbers](https://raw.githubusercontent.com/slhsxcmy/vscode-double-line-numbers/master/images/icon.png)

## Dynamic Line Highlighting with Embedded Numbers

This VS Code extension enhances your coding experience by providing both traditional line numbers in the gutter and dynamic line highlighting with embedded relative line numbers directly in your code view.

## Features

### 1. Double Line Numbers

Display line numbers both in the gutter and inline with your code, making it easier to reference lines in discussions or documentation.

### 2. Dynamic Line Highlighting

![Line Highlighting Demo](images/demo-image.png)

- **Current Line Indicator**: Highlights your current line with a distinctive solid black background
- **Embedded Relative Line Numbers**: Shows tiny relative line numbers (-9 to 9) embedded in the background pattern
- **Focus on Code**: Keep your eyes on the code instead of looking at the gutter for line numbers

## Installation

1. Open VS Code
2. Press `Ctrl+P` to open the Quick Open dialog
3. Type `ext install slhsxcmy.vscode-double-line-numbers`
4. Press Enter

## Usage

### Double Line Numbers

- Enable/disable via command palette: `Double Line Numbers: Toggle`
- Configure appearance in settings

### Line Highlighting

- Enable/disable via command palette: `Double Line Numbers: Toggle Line Highlight`
- As you move through your code, the current line is highlighted with embedded relative line numbers
- The tiny numbers show the relative distance from your current position (-9 to 9)

## Configuration

### Double Line Numbers Settings

* `vscode-double-line-numbers.enable`: Enable/disable the extension
* `vscode-double-line-numbers.backgroundColor`: Background color of the line number
* `vscode-double-line-numbers.color`: Text color of the line number
* `vscode-double-line-numbers.paddingStyle`: Padding style of the line number
* `vscode-double-line-numbers.fontWeight`: Font weight of the line number
* `vscode-double-line-numbers.fontStyle`: Font style of the line number
* `vscode-double-line-numbers.fontSize`: Font size of the line number
* `vscode-double-line-numbers.fontFamily`: Font family of the line number

### Line Highlighting Settings

* `vscode-double-line-numbers.enableLineHighlight`: Enable/disable line highlighting feature
* `vscode-double-line-numbers.highlight.patternOpacity`: Opacity of the background pattern (0-1)
* `vscode-double-line-numbers.highlight.showLineNumber`: Show/hide the central line number in the background

## Commands

* `Double Line Numbers: Toggle`: Toggle the double line numbers feature
* `Double Line Numbers: Toggle Line Highlight`: Toggle the line highlighting feature

## Development

### Building the Extension

1. Clone the repository
2. Run `npm install` to install dependencies
3. Run `npm run compile` to compile TypeScript files
4. Press `F5` to launch the extension in debug mode

## Feedback and Contributions

- File issues and suggestions on [GitHub](https://github.com/slhsxcmy/vscode-double-line-numbers)
- Contributions are welcome! Please fork the repository and submit pull requests

## License

This extension is licensed under the [MIT License](LICENSE).
