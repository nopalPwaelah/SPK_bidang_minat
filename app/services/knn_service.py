import pandas as pd

from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import LabelEncoder


def train_knn(data, k=3):

    df = pd.DataFrame(data)

    features = [
        'matematika',
        'pemrograman_dasar',
        'basis_data',
        'jaringan_komputer',
        'kecerdasan_buatan',
        'statistika'
    ]

    X = df[features]

    y = df['minat_jurusan']

    encoder = LabelEncoder()

    y_encoded = encoder.fit_transform(y)

    model = KNeighborsClassifier(
        n_neighbors=k
    )

    model.fit(X, y_encoded)

    return model, encoder