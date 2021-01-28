import json
import os

def map_urls_to_uuids(urls):
    def to_just_uuid(url: str):
            splitted_url = url.split('/')
            return splitted_url[len(splitted_url) - 1]
    return filter(lambda value: (value != ""), map(to_just_uuid, urls))

film_images_dir_content = list(map(lambda url: (url.split(".jpg")[0]), os.listdir('./film_images')))

raw_data = {}
with open('raw_data.json') as raw_data_json:
    raw_data = json.load(raw_data_json)

color_names = {}
with open('color-names.json') as color_names_json:
    for color_hex, color_name in json.load(color_names_json).items():
        color_names[color_name] = color_hex

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
modified_films_list = list(map(to_modified_films, raw_data["films"]))


def to_modified_species(specie):
    specie_id = specie["id"]

    def with_hex_color(name: str):
        name_to_work_with = name
        if name_to_work_with == "Blonde":
            name_to_work_with = "Blond"
        elif name_to_work_with == "Light Orange":
            name_to_work_with = "Peach Orange"
        hex_color = color_names.get(name_to_work_with)
        if not hex_color:
            for color_name, color_hex in color_names.items():
                if name_to_work_with in color_name:
                    hex_color = color_hex
                    break
        return {
            "name": name,
            "hex" :hex_color
        }

    return {
        "id": specie_id,
        "name": specie["name"],
        "classification": specie["classification"],
        "eye_colors": list(map(with_hex_color, specie["eye_colors"].split(", "))),
        "hair_colors": list(map(with_hex_color, specie["hair_colors"].split(", "))),
        "people": list(map_urls_to_uuids(specie["people"])),
        "films": list(map_urls_to_uuids(specie["films"])),
    }
modified_species_list = list(map(to_modified_species, raw_data["species"]))


modified_films_json = json.dumps(modified_films_list, indent=2, ensure_ascii=False)
modified_species_json = json.dumps(modified_species_list, indent=2, ensure_ascii=False)
print(modified_species_json)