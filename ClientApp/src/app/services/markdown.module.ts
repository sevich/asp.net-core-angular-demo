import { NgModule } from '@angular/core';
import { MarkdownService } from './markdown.service';
import { HighlightModule, HIGHLIGHT_OPTIONS } from "ngx-highlightjs";

@NgModule({
    imports: [
        HighlightModule
    ],
    declarations: [
        MarkdownService
    ],
    providers: [
        {
            provide: HIGHLIGHT_OPTIONS,
            useValue: {
                coreLibraryLoader: () => import('highlight.js/lib/core'),
                lineNumbersLoader: () => import('highlightjs-line-numbers.js'), // Optional, only if you want the line numbers
                languages: {
                        markdown: () => import("highlight.js/lib/languages/markdown"),
                        typescript: () => import('highlight.js/lib/languages/typescript'),
                        css: () => import('highlight.js/lib/languages/css'),
                        xml: () => import('highlight.js/lib/languages/xml')
                }
            }
        }
    ]
})
export class MarkdownModule { }
