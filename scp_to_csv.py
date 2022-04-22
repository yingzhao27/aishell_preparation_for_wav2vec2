import pandas as pd

train = "data/train/together.txt"
dev = "data/dev/together.txt"
test = "data/test/together.txt"


def get_csv(file):
    df = pd.read_csv(file,delimiter=" ",names=['id','file','text'])
    df[u'text'] = df[u'text'].apply(lambda x :" ".join(x))
    df.to_csv(f"{file}.csv", index=False)
    return df

train = get_csv(train)
dev = get_csv(dev)
test = get_csv(test)
