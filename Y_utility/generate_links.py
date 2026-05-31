import os
import re

TRACK_MAP = {
    "python": ".py",
    "bash": ".sh",
    "java": ".java",
    "javascript": ".js",
    "cpp": ".cpp",
    "c": ".c",
    "go": ".go",
    "rust": ".rs"
}

def format_title(exercise):
    return " ".join(part.capitalize() for part in exercise.split('-'))


# bash folder
def _find_bash_file(base_folder, exercise, ext):
    return exercise.replace('-', '_') + ext

# python folder
def _find_python_file(base_folder, exercise, ext):
    if not os.path.exists(base_folder):
        return exercise.replace('-', '_') + ext

    for root, dirs, files in os.walk(base_folder):
        for file in files:
            if file.endswith(ext):
                if "test" not in file.lower() and "__pycache__" not in root:
                    return file

    return exercise.replace('-', '_') + ext

# java folder
def _find_java_file(base_folder, exercise, ext):
    java_src_folder = os.path.join(base_folder, "src", "main", "java")

    if not os.path.exists(java_src_folder):
        pascal_name = "".join(part.capitalize() for part in exercise.split('-'))
        return f"src/main/java/{pascal_name}{ext}"

    for root, dirs, files in os.walk(java_src_folder):
        for file in files:
            if file.endswith(ext):
                return os.path.relpath(os.path.join(root, file), base_folder)

    pascal_name = "".join(part.capitalize() for part in exercise.split('-'))
    return f"src/main/java/{pascal_name}{ext}"


def _find_generic_fallback(base_folder, exercise, ext):
    return exercise.replace('-', '_') + ext


# finder def matchmaking
def find_actual_file(track, exercise, ext):
    base_folder = os.path.join(os.path.dirname(__file__), "..", track, exercise)

    TRACK_PROCESSORS = {
        "bash": _find_bash_file,
        "python": _find_python_file,
        "java": _find_java_file
    }

    processor = TRACK_PROCESSORS.get(track, _find_generic_fallback)
    return processor(base_folder, exercise, ext)


############ ---- Main ---- ############

track_input = input("Enter track name (e.g., python, bash, java): ").strip().lower()

md_file_name = f"{track_input}.md"
input_path = os.path.join(os.path.dirname(__file__), "..", "Z_Download Links", md_file_name)
output_path = os.path.join(os.path.dirname(__file__), "generated_links.txt")

if not os.path.exists(input_path):
    print(f" Error: File not found at '{input_path}'")
    exit(1)

with open(input_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

html_lines = []

for line in lines:
    line = line.strip()
    if "exercism download" not in line:
        continue

    track_match = re.search(r'--track=([^\s]+)', line)
    exercise_match = re.search(r'--exercise=([^\s]+)', line)

    if track_match and exercise_match:
        track = track_match.group(1)
        exercise = exercise_match.group(1)

        ext = TRACK_MAP.get(track, ".txt")

        file_path = find_actual_file(track, exercise, ext)
        title = format_title(exercise)

        html_line = f'    <li><a href="{track}/{exercise}/{file_path}">{title}</a></li>'
        html_lines.append(html_line)

with open(output_path, "w", encoding="utf-8") as f:
    for html_line in html_lines:
        f.write(html_line + "\n")

print(f" Successfully generated {len(html_lines)} links inside child folder")