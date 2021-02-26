params.options = [:]
options = [publish_dir: 'html',
           publish_mode: 'copy']
process MD_HTML {
  tag "$meta.id"
  publishDir "${params.outdir}/${options.publish_dir}",
             mode: options.publish_mode

  conda (params.conda ? "markdown=3.2.2 pymdown-extensions=7.1" : null)

  input: path md
  output: path("*.html"), emit: html
  script:
  params.options.forEach{key, value -> options[key]=value}
  """
  # write markdown_to_html.py
  SEP='"""'
  cat <<EOT > markdown_to_html.py
#!/usr/bin/env python
from __future__ import print_function
import argparse
import markdown
import os
import sys
import io


def convert_markdown(in_fn):
    input_md = io.open(in_fn, mode="r", encoding="utf-8").read()
    html = markdown.markdown(
        "[TOC]\n" + input_md,
        extensions=["pymdownx.extra", "pymdownx.b64", "pymdownx.highlight", "pymdownx.emoji", "pymdownx.tilde", "toc"],
        extension_configs={
            "pymdownx.b64": {"base_path": os.path.dirname(in_fn)},
            "pymdownx.highlight": {"noclasses": True},
            "toc": {"title": "Table of Contents"},
        },
    )
    return html


def wrap_html(contents):
    header = \${SEP}<!DOCTYPE html><html>
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <style>
            body {
              font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
              padding: 3em;
              margin-right: 350px;
              max-width: 100%;
            }
            .toc {
              position: fixed;
              right: 20px;
              width: 300px;
              padding-top: 20px;
              overflow: scroll;
              height: calc(100% - 3em - 20px);
            }
            .toctitle {
              font-size: 1.8em;
              font-weight: bold;
            }
            .toc > ul {
              padding: 0;
              margin: 1rem 0;
              list-style-type: none;
            }
            .toc > ul ul { padding-left: 20px; }
            .toc > ul > li > a { display: none; }
            img { max-width: 800px; }
            pre {
              padding: 0.6em 1em;
            }
            h2 {

            }
        </style>
    </head>
    <body>
    <div class="container">
    \${SEP}
    footer = \${SEP}
    </div>
    </body>
    </html>
    \${SEP}
    return header + contents + footer


def parse_args(args=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("mdfile", type=argparse.FileType("r"), nargs="?", help="File to convert. Defaults to stdin.")
    parser.add_argument(
        "-o", "--out", type=argparse.FileType("w"), default=sys.stdout, help="Output file name. Defaults to stdout."
    )
    return parser.parse_args(args)


def main(args=None):
    args = parse_args(args)
    converted_md = convert_markdown(args.mdfile.name)
    html = wrap_html(converted_md)
    args.out.write(html)


if __name__ == "__main__":
    sys.exit(main())

EOT
  # run the script
  python markdown_to_html.py $md -o ${md.replaceFirst(/.md$/, ".html")}
  """
}
