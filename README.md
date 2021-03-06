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

| Name                                  | Target language   | Type                                                 | Words                                                        | Participants                                          | Availability                                                                                                                                                          |
|:--------------------------------------|:------------------|:-----------------------------------------------------|:-------------------------------------------------------------|:------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SVL12K                                | English           | Self-assessed 5-point scale                          | 12 000 from the SVL wordlist                                 | 16 L2Ls based in Japan                                | [Personal website](http://yoehara.com/esl-vocabulary-dataset/)                                                                                                        |
| EVKD1                                 | English           | Multiple choice (4) definitions from word in context | 100 from the XXX vocabulary size test                        | 100 L2Ls mainly based in Japan                        | [Personal website](http://yoehara.com/EVKD1/) (currently broken; direct request via email)                                                                            |
| TestYourVocab                         | English           | Self-assessed yes/no                                 | ~90-160 per participant from bank of 616                     | >1 627 968 L1Ls, >5 772 534 L2Ls from around the word | Direct request via email                                                                                                                                              |
| ECP (English Crowdsourcing Project)   | English           | Lexical decision                                     | ~300-1000 per participant from bank of 62 000                | 700 000                                               | [Repository](https://osf.io/v25ek/)                                                                                                                                   |
| ELP (English Lexicon Project)         | English           | Lexical decision                                     | TODO                                                         | TODO                                                  | [Website](https://elexicon.wustl.edu/) [Tool (3rd party)](https://github.com/JackEdTaylor/read-elp] [Repository](https://osf.io/eu5ca/)                               |
| BLP (British Lexicon Project)         | English           | Lexical decision                                     | TODO                                                         | TODO                                                  | [Departmental website](http://crr.ugent.be/blp/txt/)                                                                                                                  |
| FLP (French Lexicon Project)          | French            | Lexical decision                                     | TODO                                                         | TODO                                                  | [Repository](https://osf.io/f8kc4/)                                                                                                                                   |
| DCP (Dutch Crowdsourcing Project)     | Dutch             | Lexical decision                                     | TODO                                                         | TODO                                                  | [Repository](https://osf.io/5fk8d/)                                                                                                                                   |
| DLP (Dutch Lexicon Project)           | Dutch             | Leixcal decision                                     | TODO                                                         | TODO                                                  | [Repository]()                                                                                                                                                        |
| DLP2 (Dutch Lexicon Project 2)        | Dutch             | Lexical decision                                     | TODO                                                         | TODO                                                  | [Repository]()                                                                                                                                                        |
| SPALEX                                | Spanish           | Lexical decision                                     | TODO                                                         | TODO                                                  | [Repository](https://figshare.com/projects/SPALEX/29722)                                                                                                              |
| WordBank (Collection of many studies) | Multiple          | Multiple                                             | MacArthur-Bates Communicative Development Inventory (MB-CDI) | Children; TODO                                        | [Departmental website](http://wordbank.stanford.edu/) (accessed through public MySQL database, same as the [wordbankr](https://github.com/langcog/wordbankr) package) |

[//]: # (END_TABLE)

## Relevant word features

These datasets include features of words which are highly relevant to
vocabulary inventory modelling. The most important beyond frequency, which is
not covered here are age of acquisition and concreteness.

## Candidates for addition

### Individual datasets

| Name | Link | Commment |
|------|------|----------|
| X | https://www.iris-database.org/iris/app/home/detail?id=york%3a938002&ref=search |  |
| X | https://www.iris-database.org/iris/app/home/detail?id=york%3a939292&ref=search |  |
| X | https://www.iris-database.org/iris/app/home/detail?id=york%3a852665&ref=search |  |

### Lists

 * [List of word knowledge megastudies on the webpages of the Center for Reading Research at Ghent University](http://crr.ugent.be/programs-data/megastudy-data-available)
 * [Iris database](https://www.iris-database.org/)
 * Chase references from *Milton, J. (2009). Measuring Second Language Vocabulary Acquisition.*


### Cannot find trial level data

| Name | URL | First author contact | Status |
| The Chinese Lexicon Project | https://link.springer.com/article/10.3758/s13428-016-0810-5 | http://clst.fed.cuhk.edu.hk/faculty/prof-tse-chi-shing/ | TODO |
