# ruby-words-counter

## Business functionality 
Processing text files and counting word appearances in text.

## API 

Process local file example: 

http://localhost:9292/process?file_path=./sample_data/bible.txt

Process body text: 
```bash
curl -X POST -H "Content-Type: text/plain" --data "this is raw data" http://localhost:9292/process
```

Process remote file: http://localhost:9292/process?url=https://www.w3.org/TR/PNG/iso_8859-1.txt

## Run:
- run docker-compose up to spinup the db
- create schema : words_counter
- type *puma* in terminal in project's location


## Implementation details

Sinatra with Ruby ( no Rails ). Data persisted to mySQL ( `docker-compose` attached to the project ).
Storage partitioned into 64 tables (configurable) to reduce query time.
Data partitioned according to it content, accumulated in memory  and then ingested into database with aggregated insert.
To speedup processing , data ingested with inserts only.

Data retrieval - data retrieved by simple group by and sum, from 1 table according to partition. 

## Assumptions

- Code was tested with English text only. 
- Tried to find stable streaming solution for ruby, but was not able to find
_ Approach is naieve for exercise only. Production architecture probably requires intermediate storage as queue for example and 
multiple consumers processing and storing that data.  
- More optimization might be introduced: implementation of bloom filter for example to avoid db accesses for never seen words

 
 ## Performance benchmarks
 - Disturbed song "Voices": https://www.youtube.com/watch?v=0eJkXZcRrkA : 20ms
 - Bible : 2 seconds
 
 
 ## Important to know
 - **heaven** appears 206 times in bible
 - **hell** appears only 24 times

**Everything is gonna be alright !**
