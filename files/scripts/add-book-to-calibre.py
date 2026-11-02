#!/usr/bin/env python3
"""Shelfmark post-download hook: add each finished book to Calibre, then delete it."""

from json import load
from os import environ
from pathlib import Path
from sys import argv, stderr
from urllib.parse import quote
from urllib.request import Request, urlopen

URL = environ["CALIBRE_URL"].rstrip("/")
LIBRARY = environ.get("CALIBRE_LIBRARY", "library")


def add(path: Path) -> None:
    name = quote(path.name, safe="")

    with path.open("rb") as body:
        request = Request(
            f"{URL}/{name}/{LIBRARY}",
            data=body,
            method="POST",
            headers={
                "Content-Type": "application/octet-stream",
                "Content-Length": str(path.stat().st_size),
            },
        )

        with urlopen(request, timeout=250) as response:
            result = load(response)

    if "book_id" in result:
        print(f"added {path.name} as book {result['book_id']}", file=stderr)
    else:
        print(
            f"already in library: {path.name} {result.get('duplicates')}",
            file=stderr,
        )

    path.unlink()


def main(target: str) -> None:
    root = Path(target)
    files = (
        [root] if root.is_file() else sorted(p for p in root.rglob("*") if p.is_file())
    )

    for path in files:
        add(path)

    if root.is_dir():
        for folder in sorted((p for p in root.rglob("*") if p.is_dir()), reverse=True):
            folder.rmdir()


if __name__ == "__main__":
    main(argv[1])
