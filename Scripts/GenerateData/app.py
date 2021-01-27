import json
import os

def map_urls_to_uuids(urls):
    def to_just_uuid(url: str):
            splitted_url = url.split('/')
            return splitted_url[len(splitted_url) - 1]
    return filter(lambda value: (value != ""), map(to_just_uuid, urls))

film_images_dir_content = list(map(lambda url: (url.split(".jpg")[0]), os.listdir('./film_images')))

data = {}

with open('data.json') as data_json:
    data = json.load(data_json)

def to_modified_films(film):
    film_id = film["id"]
    film_to_return = {
        "id": film_id,
        "title": film["title"],
        "original_title": film["original_title"],
        "original_title_romanised": film["original_title_romanised"],
        "description": film["description"],
        "director": film["director"],
        "producer": film["producer"],
        "people": list(map_urls_to_uuids(film["people"])),
        "species": list(map_urls_to_uuids(film["species"])),
        "locations": list(map_urls_to_uuids(film["locations"])),
        "vehicles": list(map_urls_to_uuids(film["vehicles"])),
        "release_date": int(film["release_date"]),
        "running_time": int(film["running_time"]),
        "rt_score": int(film["rt_score"])
    }
    if film_id in film_images_dir_content:
        film_to_return["image_url"] = f"{film_id}.jpg"
    else:
        print(f"no image for {film_id}")
    return film_to_return

modified_films = list(map(to_modified_films, data["films"]))
# print(json.dumps(modified_films, indent=2, ensure_ascii=False))