# Vocabulary acquisition datasets

This repository contains a Snakemake workflow to do some preparation of various
datasets relevant to modelling vocabulary with an eye towards modelling
receptive vocabulary inventories. It can also do some enrichment of the data.
The output formats are DuckDB and Arrow tables, which can be used comfortably
from Python or R.

## Vocabulary inventory datasets

These datasets 

L1Ls = 1nd language learners
L2Ls = 2nd language learners

[//]: # (START_TABLE)
|    | Name                                | Target language   | Type                                                 | Words                                         | Participants                                          | Availability                                                                               |
|---:|:------------------------------------|:------------------|:-----------------------------------------------------|:----------------------------------------------|:------------------------------------------------------|:-------------------------------------------------------------------------------------------|
|  0 | SVL12K                              | English           | Self-assessed 5-point scale                          | 12 000 from the SVL wordlist                  | 16 L2Ls based in Japan                                | [Personal website](http://yoehara.com/esl-vocabulary-dataset/)                             |
|  1 | EVKD1                               | English           | Multiple choice (4) definitions from word in context | 100 from the XXX vocabulary size test         | 100 L2Ls mainly based in Japan                        | [Personal website](http://yoehara.com/EVKD1/) (currently broken; direct request via email) |
|  2 | TestYourVocab                       | English           | Self-assessed yes/no                                 | ~90-160 per participant from bank of 616      | >1 627 968 L1Ls, >5 772 534 L2Ls from around the word | Direct request via email                                                                   |
|  3 | ECP (English Crowdsourcing Project) | English           | Lexical decision                                     | ~300-1000 per participant from bank of 62 000 | 700 000                                               | [Repository](https://osf.io/v25ek/)                                                        |
|  4 | ELP (English Lexicon Project)       | English           | Lexical decision                                     | TODO                                          | TODO                                                  | [Repository](https://osf.io/rpx87/)                                                        |
|  5 | FLP (French Lexicon Project)        | French            | Lexical decision                                     | TODO                                          | TODO                                                  | [Repository](https://osf.io/f8kc4/)                                                        |
[//]: # (END_TABLE)

## Relevant word features

These datasets include features of words which are highly relevant to
vocabulary inventory modelling. The most important beyond frequency, which is
not covered here are age of acquisition and concreteness.

## TODO:

| Name | Link | Commment |
--------------------------
|  |  |  |
|  | https://www.iris-database.org/iris/app/home/detail?id=york%3a938002&ref=search |  |
|  | https://www.iris-database.org/iris/app/home/detail?id=york%3a939292&ref=search |  |
|  | https://www.iris-database.org/iris/app/home/detail?id=york%3a852665&ref=search |  |
