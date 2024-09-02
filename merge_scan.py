import sys
import subprocess
from pathlib import Path
import pprint

def seperate_pdf(scan_pdf_file):
    pdf_file = Path(scan_pdf_file)
    base = f"{pdf_file.stem}_temp_"
    subprocess.run(f"pdfseparate {scan_pdf_file} {base}%d.pdf", shell=True, capture_output=True)
    pages = []
    i = 1
    while (True):
        name = f"{base}{i}.pdf"
        file = Path(name)
        if file.is_file():
            pages.append(name)
        else:
            break
        i += 1
    return pages

if __name__ == "__main__":
    if len(sys.argv) !=3:
        print(f"Argument error\n Usage: {sys.argv[0]} <odd_scan.pdf> <even_scan.pdf>")
        exit(1)

    odd_file = sys.argv[1]
    even_file = sys.argv[2]

    odd_stem = Path(odd_file).stem
    even_stem = Path(even_file).stem

    odd_pages = seperate_pdf(sys.argv[1])
    even_pages = seperate_pdf(sys.argv[2])

    count = len(odd_pages)

    if count != len(even_pages):
        print(f"Error, odd page count {count} and even page count {len(even_pages)} are not same")
        exit(1)

    command = "pdfunite "
    for i in range(count):
        command += f"{odd_pages[i]} "
        command += f"{even_pages[count-1-i]} "
    command += f"{odd_stem}_{even_stem}.pdf"
    #print(command)
    ret = subprocess.run(command, shell=True, capture_output=True)
    subprocess.run(f"rm {odd_stem}_temp_*.pdf", shell=True, capture_output=True)
    subprocess.run(f"rm {even_stem}_temp_*.pdf", shell=True, capture_output=True)

