import nltk
from nltk.stem.lancaster import LancasterStemmer
import numpy as np
import pickle
from keras.models import load_model
import json
import random


nltk.download('punkt')
stemmer = LancasterStemmer()

with open(r"intents.json") as file:
    data = json.load(file)

with open(r"medicines.json") as file:
    med_data = json.load(file)
known_medicines = med_data.keys()

words = pickle.load(open(r'words.pkl', 'rb'))
labels = pickle.load(open(r'labels.pkl', 'rb'))

model = load_model(r"chatbot_model.h5")


def bag_of_words(s, words):
    bag = [0 for _ in range(len(words))]
    s_words = nltk.word_tokenize(s)
    s_words = [stemmer.stem(word.lower()) for word in s_words]
    for se in s_words:
        for i, w in enumerate(words):
            if w == se:
                bag[i] = 1
    return np.array(bag)


def extract_medicine(s):
    tokens = nltk.word_tokenize(s.lower())
    for token in tokens:
        if token in known_medicines:
            return token
    return None


def check_medicine(medicine):
    medicine_old = "Aspirin"
    if medicine in med_data[medicine_old]:
        return False
    else:
        return True
    

def chat():
    print("Start talking with the bot (type 'quit' to stop)!")
    while True:
        inp = input("You: ")
        if inp.lower() == 'quit':
            break

        vars = extract_medicine(inp)
        print(f"Extracted variables: {vars}")

        bow = bag_of_words(inp, words)
        results = model.predict(np.array([bow]))[0]
        results_index = np.argmax(results)
        tag = labels[results_index]

        if results[results_index] > 0.7:
            for intent in data['intents']:
                if intent['tag'] == tag:
                    responses = intent['responses']
            response = random.choice(responses)
            if not vars:
                print(response)
        else:
            print("I didn't get that, try again.")
chat()
