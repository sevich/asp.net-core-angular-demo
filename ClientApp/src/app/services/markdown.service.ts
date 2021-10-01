import { Injectable } from "@angular/core";
import { Renderer } from "marked";
import * as marked from "marked";
import * as DOMPurify from "dompurify";

@Injectable()
export class MarkdownService {
  private readonly md: typeof marked = marked;

  constructor() {
    this.md.setOptions({
      renderer: new Renderer(),
      highlight: (code, language) => {
        const hljs = require('highlight.js');
        const validLanguage = hljs.getLanguage(language) ? language : 'plaintext';
        return hljs.highlight(validLanguage, code).value;
      },
      pedantic: false,
      gfm: true,
      breaks: false,
      sanitize: false,
      smartLists: true,
      smartypants: false,
      xhtml: false,
    });
  }

  generateHtml(raw: string): string {
    return DOMPurify.sanitize(this.md(raw));
  }
}