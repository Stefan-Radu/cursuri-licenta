import tensorflow as tf
from tensorflow import keras
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential, load_model
from keras.layers import Conv2D, MaxPooling2D, BatchNormalization, \
    Dropout, Flatten, Dense, AveragePooling2D
from keras.layers.experimental.preprocessing import RandomContrast
from keras.callbacks import ModelCheckpoint, EarlyStopping
from keras.constraints import unit_norm
from keras.optimizers import Adam

import seaborn as sn
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import cv2


class SolidCNN:
    # path-urile din kaggle catre setul de date
    TRAIN_PATH = '../input/ct-fixed-dataset/fixed-dataset/train'
    TRAIN_PATH_CSV = '../input/ct-fixed-dataset/fixed-dataset/train.txt'
    AUG_SAVE_PATH = "../input/ct-fixed-dataset/fixed-dataset/augumented/"
    VALIDATION_PATH = '../input/ct-fixed-dataset/fixed-dataset/validation/'
    VALIDATION_PATH_CSV = '../input/ct-fixed-dataset/fixed-dataset/validation.txt'
    TEST_PATH = '../input/ct-fixed-dataset/fixed-dataset/test/'
    TEST_PATH_CSV = '../input/ct-fixed-dataset/fixed-dataset/test.txt'

    # constante
    BATCH_SIZE = 32
    IMG_SIZE = 50
    EPOCHS = 1000

    @staticmethod
    def TrainDataGenerator():
        # citesc si creez generator de date pentru train
        labels_df = pd.read_csv(SolidCNN.TRAIN_PATH_CSV, dtype=str)

        # img augumentation
        img_datagen = ImageDataGenerator(
            rescale=1.0 / 255,
#             fill_mode='constant',
#             width_shift_range=0.05,
#             height_shift_range=0.05,
            shear_range=8,
            horizontal_flip=True,
            vertical_flip=True,
#             rotation_range=10,
        )

        # generator
        gen = img_datagen.flow_from_dataframe(
                dataframe=labels_df,
                directory=SolidCNN.TRAIN_PATH,
                x_col="id",
                y_col="label",
                target_size=(SolidCNN.IMG_SIZE, SolidCNN.IMG_SIZE),
                color_mode="grayscale",
                batch_size=SolidCNN.BATCH_SIZE,
                class_mode="categorical",
                shuffle=True,
#                 save_to_dir=SolidCNN.AUG_SAVE_PATH,
                save_format='png')

        return gen


    @staticmethod
    def ValidationDataGenerator():
        # citesc si creez generator de date pentru validare
        labels_df = pd.read_csv(SolidCNN.VALIDATION_PATH_CSV, dtype=str)
        img_datagen = ImageDataGenerator(rescale=1.0 / 255)
        # generator
        gen = img_datagen.flow_from_dataframe(
                dataframe=labels_df,
                directory=SolidCNN.VALIDATION_PATH,
                x_col="id",
                y_col="label",
                target_size=(SolidCNN.IMG_SIZE, SolidCNN.IMG_SIZE),
                color_mode="grayscale",
                batch_size=SolidCNN.BATCH_SIZE,
                class_mode="categorical",
                shuffle=True)

        return gen


    @staticmethod
    def TestDataGenerator():
        # acelasi lucru ca mai sus doar ca scot doar coloana cu id
        # pentru ca in test nu am labels
        labels_df = pd.read_csv(SolidCNN.TEST_PATH_CSV, dtype=str)
        img_datagen = ImageDataGenerator(rescale=1.0 / 255)
        gen = img_datagen.flow_from_dataframe(
            dataframe=labels_df,
            x_col="id",
            y_col=None,
            directory=SolidCNN.TEST_PATH,
            target_size=(SolidCNN.IMG_SIZE, SolidCNN.IMG_SIZE),
            color_mode="grayscale",
            batch_size=1,
            class_mode=None,
            shuffle=False)

        return gen


    @staticmethod
    def Model():
        # structura modelului dupa trial and error
        model = Sequential(layers=[
            RandomContrast(factor=0.4, input_shape=(50, 50, 1)),

            Conv2D(filters=27, kernel_size=3, strides=1, activation='relu', \
                   input_shape=(50, 50, 1)),
            BatchNormalization(),

            Conv2D(filters=54, kernel_size=3, strides=1, activation='relu'),
            BatchNormalization(),
            MaxPooling2D(),
            Dropout(0.37),

            Conv2D(filters=108, kernel_size=3, strides=1, activation='relu'),
            BatchNormalization(),
            MaxPooling2D(),

            Conv2D(filters=216, kernel_size=3, strides=1, activation='relu'),
            BatchNormalization(),
            MaxPooling2D(),
            Dropout(0.37),

            Flatten(),
            Dense(532, activation='relu'),
            Dropout(0.37),
            Dense(108, activation='relu'),
            Dropout(0.37),
            Dense(27, activation='relu'),
            Dropout(0.37),
            Dense(3, activation='softmax')
        ], name='SolidCNN')

        # compileare cu optimizator Adam
        optimizer = Adam()
        model.compile(
            loss='categorical_crossentropy',
            optimizer=optimizer,
            metrics=['accuracy']
        )

        return model


    @staticmethod
    def Train(model):
        # scot datele de antrenare
        training_data_gen = SolidCNN.TrainDataGenerator();
        train_steps = training_data_gen.n // training_data_gen.batch_size
        # scot datele de validare
        validation_data_gen = SolidCNN.ValidationDataGenerator();
        validation_steps = validation_data_gen.n // validation_data_gen.batch_size

        # callback sa imi salvez modelele pe parcurs cand ajung 
        # la un nou punct de maxim cu acuratetea
        checkpoint_callback = ModelCheckpoint(
            filepath='model_{val_loss:.3f}_{val_accuracy:.3f}.h5',
            save_weights_only=False,
            monitor='val_accuracy',
            mode='max',
            save_best_only=True,
            verbose=1)

        # early stopping callback care asculta pe increase de acuratete
        # pana la urma nu l-am mai folosit
        early_stopping_callback = EarlyStopping(
            monitor="val_accuracy",
            patience=12,
            verbose=1,
            mode="max",
        )

        # incarcare optionala de model
        # foloseama asta cand se termina un set de epoci
        # dar imi doream sa continui anternarea
        # model = load_model('./model_0.609_0.787.h5')

        # antrenarea efectiva
        history = model.fit(
            training_data_gen,
            steps_per_epoch=train_steps,
            validation_data=validation_data_gen,
            validation_steps=validation_steps,
            epochs=SolidCNN.EPOCHS,
            callbacks=[
                checkpoint_callback,
#                 early_stopping_callback,
            ],
        )

        return history


    @staticmethod
    def Plot(history):
        # randare de grafice cu datele scoase dupa antrenare
        history = history.history

        params = ['accuracy', 'val_accuracy']
        accuracy, val_accuracy = tuple(history[p] for p in params)
        epochs_range = range(SolidCNN.EPOCHS)

        plt.title('accuracy')
        plt.figure(figsize=(17, 17))
        plt.legend(loc='lower right')
        plt.plot(epochs_range, accuracy, label='train accuracy')
        plt.plot(epochs_range, val_accuracy, label='validation accuracy')


    @staticmethod
    def Test(model):
        # prezicere pe setul de test
        test_data_gen = SolidCNN.TestDataGenerator();
        test_steps = test_data_gen.n // test_data_gen.batch_size

        prediction = model.predict(
            test_data_gen,
            steps=test_steps,
            verbose=1
        )
        prediction = np.argmax(prediction, axis = 1)

        # salvare ca csv
        image_names = test_data_gen.filenames
        results_df = pd.DataFrame({
            "id": image_names,
            "label": prediction
        })
        results_df.to_csv("last.csv", index=False)

        return prediction


    @staticmethod
    def VisualizeModel():
        # functie folosita ca sa vizulizez efectele 
        # augumentarii si a diverselor layere asupra 
        # imaginilor. 
        # comentam si decomentam inainte de rulare in
        # functie de efectul dorit

        # incarc prima imagine
        img = cv2.imread('../input/ct-fixed-dataset/fixed-dataset/train/00075648-2e8.png')
        plt.imshow(img)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#         plt.imshow(img)

        # clona a modelului fara straturi dense cu 1 filtru per layer
        model = Sequential(layers=[
            Conv2D(filters=1, kernel_size=3, strides=1, activation='relu', input_shape=(50, 50, 1)),
            BatchNormalization(),
            Conv2D(filters=1, kernel_size=3, strides=1, activation='relu'),
            BatchNormalization(),
#             AveragePooling2D(),
            MaxPooling2D(),
#             BatchNormalization(),

            Conv2D(filters=1, kernel_size=3, strides=2, activation='relu'),
            BatchNormalization(),

            Conv2D(filters=1, kernel_size=3, strides=1, activation='relu'),
            BatchNormalization(),
            MaxPooling2D(),
        ], name='SolidCNN')

        batch = img.reshape(-1, 50, 50, 1)
        # img augumentation
        img_datagen = ImageDataGenerator(
            fill_mode='constant',
            width_shift_range=0.05,
            height_shift_range=0.05,
            shear_range=3,
            rotation_range=5
        )
        iterator = img_datagen.flow(batch, batch_size=1)

        # vizualizarea efectiva
        batch = iterator.next()
        conv_img = model.predict(batch)
#             layer = RandomContrast(factor=0.5)
#             conv_img = layer(batch, training=True)
        print(conv_img.shape)
        conv_img = np.squeeze(conv_img, axis=0)
        conv_img = conv_img.reshape(conv_img.shape[:2])
        print(conv_img.shape)
        plt.imshow(conv_img)


    @staticmethod
    def GetConfusionMatrix(predicted_labels, ground_truth_labels):
        # generare matrice de confuzie ca in laborator
        num_labels = ground_truth_labels.max() + 1
        conf_mat = np.zeros((num_labels, num_labels))

        for i in range(len(predicted_labels)):
            conf_mat[ground_truth_labels[i], predicted_labels[i]] += 1
        return  conf_mat


    @staticmethod
    def RenderConfusionMatrix(model):
        test_data_gen = SolidCNN.ValidationDataGenerator(shuffle=False);
        test_steps = test_data_gen.n // test_data_gen.batch_size

        # prezicere pe setul de validare
        prediction = model.predict(
            test_data_gen,
            steps=test_steps,
            verbose=1
        )
        predicted_labels = np.argmax(prediction, axis=1)
        # print(predicted_labels)

        test_data_df = pd.read_csv(SolidCNN.VALIDATION_PATH_CSV, dtype=str)
        test_labels = test_data_df['label'].to_numpy(dtype=np.int)
        # print(test_labels)

        # generare a datelor
        conf_mat = SolidCNN.GetConfusionMatrix(predicted_labels, test_labels)
        conf_mat_df = pd.DataFrame(conf_mat, range(3), range(3))

        # display ca heatmap matrice de confuzie
        plt.figure(figsize=(7, 7))
        sn.heatmap(conf_mat_df,
                   annot=True,
                   annot_kws={"size": 21},
                   square=True,
                   cmap="Wistia")
        plt.show()

        return prediction


if __name__ == '__main__':
    ##### aici rulam pentru antrenare ########
    model = SolidCNN.Model()
    history = SolidCNN.Train(model)
    SolidCNN.Plot(history)

    ##### aici rulam pentru generarea predictiei ########
#     model = load_model('model_0.603_0.836.h5')
#     prediction = SolidCNN.Test(model)

    ##### aici rulam pentru vizulizare ########
#     SolidCNN.VisualizeModel()

    ##### aici rulam pentru generarea matricii de confuzie ########
#     model = load_model('../input/models/model_1.013_0.844.h5')
#     print(model.summary())
#     SolidCNN.RenderConfusionMatrix(model)
