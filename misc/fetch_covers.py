import os, requests
from io import BytesIO
from PIL import Image

API_KEY = "" # get from https://console.cloud.google.com/apis/credentials
CX = "" # get from https://programmablesearchengine.google.com/controlpanel/all

def get_first_image_url(query):
    url = "https://www.googleapis.com/customsearch/v1"
    params = {
        "q": query,
        "cx": CX,
        "key": API_KEY,
        "searchType": "image",
        "num": 1,
    }
    r = requests.get(url, params=params)
    r.raise_for_status()
    items = r.json().get("items")
    if items:
        return items[0]["link"]
    return None

def download_and_save(img_url, out_path):
    try:
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                          "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36"
        }
        r = requests.get(img_url, headers=headers, timeout=10)
        r.raise_for_status()
        img = Image.open(BytesIO(r.content))
        img.save(out_path, "JPEG")
        return True
    except requests.exceptions.RequestException as e:
        print(f"  Skipping {img_url}: {e}")
        return False
    except Exception as e:
        print(f"  Failed to save {img_url}: {e}")
        return False


def main(folder):
    for fname in os.listdir(folder):
        if not fname.lower().endswith(".mp3"):
            continue
        base = os.path.splitext(fname)[0]
        query = base
        print("Searching for:", query)
        img_url = get_first_image_url(query)
        if img_url:
            outname = os.path.join(folder, base + ".jpg")
            print(" ->", img_url)
            success = download_and_save(img_url, outname)
            if not success:
                print(f"  Could not download {base}")
        else:
            print("  No result")


if __name__ == "__main__":
    import sys
    folder = sys.argv[1] if len(sys.argv) > 1 else "."
    main(folder)
