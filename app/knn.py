import math

def euclidean(a, b):
    return math.sqrt(sum((x - y) ** 2 for x, y in zip(a, b)))

def normalisasi(data):
    min_vals = [min(col) for col in zip(*data)]
    max_vals = [max(col) for col in zip(*data)]

    norm = []
    for row in data:
        norm_row = []
        for i, val in enumerate(row):
            if max_vals[i] - min_vals[i] == 0:
                norm_row.append(0)
            else:
                norm_row.append((val - min_vals[i]) / (max_vals[i] - min_vals[i]))
        norm.append(norm_row)

    return norm

def knn(data_training, input_data, k=3):

    fitur = [[d["ipk"], d["algoritma"], d["basis_data"]] for d in data_training]

    fitur_norm = normalisasi(fitur + [input_data])
    input_norm = fitur_norm[-1]
    data_norm = fitur_norm[:-1]

    jarak = []

    for i, d in enumerate(data_training):
        dist = euclidean(input_norm, data_norm[i])

        jarak.append({
            "label": d["label"],
            "jarak": dist
        })

    jarak = sorted(jarak, key=lambda x: x["jarak"])

    tetangga = jarak[:k]

    voting = {}
    for t in tetangga:
        voting[t["label"]] = voting.get(t["label"], 0) + 1

    hasil = max(voting, key=voting.get)

    return {
        "hasil": hasil,
        "voting": voting,
        "tetangga": tetangga
    }