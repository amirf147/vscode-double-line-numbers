import * as vscode from 'vscode';

/**
 * Manages the highlighting of the current line with embedded line numbers
 */
export class LineHighlightManager {
  private currentEditor: vscode.TextEditor | undefined;
  private currentLineDecoration: vscode.TextEditorDecorationType | undefined;
  private disposables: vscode.Disposable[] = [];

  /**
   * Constructor for LineHighlightManager
   */
  constructor() {
    // Register event handlers
    this.disposables.push(
      vscode.window.onDidChangeTextEditorSelection(this.updateHighlight.bind(this)),
      vscode.window.onDidChangeActiveTextEditor(editor => {
        this.currentEditor = editor;
        if (editor) {
          this.updateHighlight({ textEditor: editor, selections: editor.selections });
        }
      }),
      // Listen for configuration changes
      vscode.workspace.onDidChangeConfiguration(e => {
        if (e.affectsConfiguration('vscode-double-line-numbers') && this.currentEditor) {
          this.updateHighlight({ textEditor: this.currentEditor, selections: this.currentEditor.selections });
        }
      })
    );
  }

  /**
   * Creates an SVG background with the line number embedded in a pattern
   * @param lineNumber The line number to display in the background
   * @returns A data URI containing the SVG
   */
  private createLineNumberBackground(lineNumber: number): string {
    // Get theme colors for better integration
    const colorTheme = vscode.window.activeColorTheme;
    const isDark = colorTheme.kind === vscode.ColorThemeKind.Dark || colorTheme.kind === vscode.ColorThemeKind.HighContrast;
    
    // Get configuration options
    const config = vscode.workspace.getConfiguration('vscode-double-line-numbers');
    const patternOpacity = config.get('highlight.patternOpacity', 0.3);
    const showLineNumber = config.get('highlight.showLineNumber', true);
    
    // Calculate the pattern size and number positions
    const patternWidth = 70; // 7 blocks of 10px each
    const patternHeight = 20;
    const blockSize = 10;
    
    // Calculate relative line number (between -9 and 9)
    // This gets the relative position from the current line
    const editor = vscode.window.activeTextEditor;
    let relativeNumber = 0;
    
    if (editor) {
      const currentLine = editor.selection.active.line + 1; // 1-based
      relativeNumber = lineNumber - currentLine;
      
      // Clamp to range -9 to 9
      relativeNumber = Math.max(-9, Math.min(9, relativeNumber));
    }
    
    // Create an SVG with larger numbers only in the top row
    const svgContent = `
      <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
        <defs>
          <pattern id="checker" width="${patternWidth}" height="${patternHeight}" patternUnits="userSpaceOnUse">
            <!-- Solid black background -->
            <rect width="${patternWidth}" height="${patternHeight}" fill="#000000"/>
            
            <!-- Top row number (7th block) - larger white text (3x previous size) -->
            <text x="${blockSize * 6 + blockSize/2}" y="5" font-family="monospace" font-size="9px" text-anchor="middle" font-weight="normal" fill="#ffffff" style="stroke: none;">${relativeNumber}</text>
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#checker)" opacity="${patternOpacity}"/>
        ${showLineNumber ? `
        <text x="50%" y="50%" font-family="monospace" font-size="12" text-anchor="middle" dominant-baseline="middle" fill="#ffffff" opacity="0.3">
          Line ${lineNumber}
        </text>
        ` : ''}
      </svg>
    `;
    
    // Convert to data URI
    const encodedSvg = encodeURIComponent(svgContent);
    return `data:image/svg+xml;utf8,${encodedSvg}`;
  }

  /**
   * Creates a decoration type with the SVG background
   * @param lineNumber The line number to display
   * @returns A TextEditorDecorationType with the SVG background
   *
   * /
  private createLineNumberDecoration(lineNumber: number): vscode.TextEditorDecorationType {
    return vscode.window.createTextEditorDecorationType({
      isWholeLine: true,
      backgroundColor: 'transparent',
      before: {
        contentText: '',
        textDecoration: `none; background-image: url("${this.createLineNumberBackground(lineNumber)}"); background-repeat: no-repeat; background-size: cover;`
      }
    });
  }

  /**
   * Updates the line highlight when the selection changes
   * @param event The selection change event
   */
  private updateHighlight(event: vscode.TextEditorSelectionChangeEvent): void {
    const editor = event.textEditor;
    this.currentEditor = editor;
    
    // Dispose of previous decoration if it exists
    if (this.currentLineDecoration) {
      this.currentLineDecoration.dispose();
    }
    
    // Check if highlighting is enabled in settings
    const isEnabled = vscode.workspace
      .getConfiguration('vscode-double-line-numbers')
      .get('enableLineHighlight', true);
    
    if (!isEnabled) {
      return;
    }
    
    const line = editor.selection.active.line;
    const lineNumber = line + 1; // Convert to 1-based for display
    
    // Create a new decoration for the current line
    this.currentLineDecoration = this.createLineNumberDecoration(lineNumber);
    
    // Apply the decoration
    editor.setDecorations(this.currentLineDecoration, [new vscode.Range(line, 0, line, 0)]);
  }

  /**
   * Disposes of all resources
   */
  dispose(): void {
    if (this.currentLineDecoration) {
      this.currentLineDecoration.dispose();
    }
    
    this.disposables.forEach(d => d.dispose());
  }
}
