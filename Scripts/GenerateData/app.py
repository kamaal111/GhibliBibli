#!/usr/bin/python3

import json
import os
import sys
import shutil


def to_just_uuid(url: str):
        splitted_url = url.split('/')
        return splitted_url[len(splitted_url) - 1]

def map_urls_to_uuids(urls):
    return filter(lambda value: (value != ""), map(to_just_uuid, urls))


def main(argv):
    output_path = ""
    for argument in argv:
        splitted_argument = argument.split("=")
        key_argument = splitted_argument[0]
        if key_argument == "--output" or key_argument == "-o":
            output_path = splitted_argument[1]

    if len(output_path) == 0:
        print("app.py -o --output <outputpath>")
        sys.exit(2)

    if output_path[len(output_path) - 1] != "/":
        output_path += "/"


    dirname = os.path.dirname(__file__)

    raw_data = {}
    with open(os.path.join(dirname, 'raw_data.json')) as raw_data_json:
        raw_data = json.load(raw_data_json)

    color_names = {}
    with open(os.path.join(dirname, 'color-names.json')) as color_names_json:
        for color_hex, color_name in json.load(color_names_json).items():
            color_names[color_name] = color_hex


    def with_hex_color(name: str):
        name_to_work_with = name
        if name_to_work_with == "Blonde":
            name_to_work_with = "Blond"
        elif name_to_work_with == "Light Orange":
            name_to_work_with = "Peach Orange"
        elif name_to_work_with == "Reddish brown":
            name_to_work_with = "Rosy Brown"
        elif name_to_work_with == "Bald, but beard is Brown":
            name_to_work_with = "Brown"
        hex_color = color_names.get(name_to_work_with.title().split("/")[0])
        if not hex_color:
            for color_name, color_hex in color_names.items():
                if name_to_work_with in color_name:
                    hex_color = color_hex
                    break
        if not hex_color:
            return {
                "name": "Bald",
                "hex": None
            }
        return {
            "name": name.title(),
            "hex": hex_color
        }

    def map_colors_with_hex_color(colors):
        return map(with_hex_color, colors.split(", "))


    film_images_path = os.path.join(dirname, 'film_images')
    film_images_dir_content = list(map(lambda url: (url.split(".jpg")[0]), os.listdir(film_images_path)))


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
            "rt_score": int(film["rt_score"]),
        }
        if film_id in film_images_dir_content:
            film_to_return["image_url"] = f"{film_id}.jpg"
        else:
            print(f"no image for {film_id}")
        return film_to_return

    modified_films_list = list(map(to_modified_films, raw_data["films"]))

    def to_modified_species(specie):
        return {
            "id": specie["id"],
            "name": specie["name"],
            "classification": specie["classification"],
            "eye_colors": list(map_colors_with_hex_color(specie["eye_colors"])),
            "hair_colors": list(map_colors_with_hex_color(specie["hair_colors"])),
            "people": list(map_urls_to_uuids(specie["people"])),
            "films": list(map_urls_to_uuids(specie["films"])),
        }

    modified_species_list = list(map(to_modified_species, raw_data["species"]))


    def to_modified_people(person):
        person_to_return = {
            "id": person["id"],
            "name": person["name"],
            "gender": person["gender"],
            "eye_color": with_hex_color(person["eye_color"]),
            "hair_color": with_hex_color(person["hair_color"]),
            "films": list(map_urls_to_uuids(person["films"])),
            "species": to_just_uuid(person["species"]),
        }
        person_age = person["age"]
        if len(person_age) > 0:
            person_to_return["age"] = person_age
        return person_to_return

    modified_people_list = list(map(to_modified_people, raw_data["people"]))


    def to_modified_locations(location):
        return {
            "id": location["id"],
            "name": location["name"],
            "climate": location["climate"],
            "terrain": location["terrain"],
            "surface_water": int(location["surface_water"]),
            "films": list(map_urls_to_uuids(location["films"])),
        }

    modified_locations_list = list(map(to_modified_locations, raw_data["locations"]))


    def to_modified_vehicles(vehicle):
        return {
            "id": vehicle["id"],
            "name": vehicle["name"],
            "description": vehicle["description"],
            "vehicle_class": vehicle["vehicle_class"],
            "length": int(vehicle["length"].replace(",", "")),
            "pilot": to_just_uuid(vehicle["pilot"]),
            "films": to_just_uuid(vehicle["films"]),
        }

    modified_vehicles_list = list(map(to_modified_vehicles, raw_data["vehicles"]))

    with open(f"{output_path}films.json", 'w') as films_json_file:
        json.dump(modified_films_list, films_json_file, indent=2, ensure_ascii=False)
    with open(f"{output_path}species.json", 'w') as species_json_file:
        json.dump(modified_species_list, species_json_file, indent=2, ensure_ascii=False)
    with open(f"{output_path}people.json", 'w') as people_json_file:
        json.dump(modified_people_list, people_json_file, indent=2, ensure_ascii=False)
    with open(f"{output_path}locations.json", 'w') as locations_json_file:
        json.dump(modified_locations_list, locations_json_file, indent=2, ensure_ascii=False)
    with open(f"{output_path}vehicles.json", 'w') as vehicles_json_file:
        json.dump(modified_vehicles_list, vehicles_json_file, indent=2, ensure_ascii=False)
    new_images_dir = f"{output_path}/Images"
    if not os.path.exists(new_images_dir):
        os.makedirs(new_images_dir)
    for image_name in film_images_dir_content:
        image_path = f"{image_name}.jpg"
        shutil.copy2(os.path.join(film_images_path, image_path), os.path.join(new_images_dir, image_path))


if __name__ == "__main__":
   main(sys.argv[1:])