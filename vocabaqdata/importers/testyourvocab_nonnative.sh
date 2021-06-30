echo "Creating tables"

tab='	'

duckdb $4 <<END
create table users (
    user_id int,
    datetime datetime,
    year_born int,
    month_born int,
    gender int,
    nationality int,
    nationality_nonnative int
);
create table answers (
    user_id int,
    rank int,
    known int
);
create table ranks (
    word string,
    rank int
);
END

echo "Importing users"

duckdb $4 <<END
PRAGMA set_progress_bar_time=1;
COPY users FROM '$1 ( DELIMETER '$tab', QUOTE '', NULL 'NULL', HEADER 1 );
END

echo "Filtering answers"

users_unique=$(dirname $1)/users_nonnative_answers_unique.tsv

tail +2 $1 | sort -k1n -k2n -u --buffer-size=30% - > $users_unique

echo "Importing answers"

duckdb $4 <<END
PRAGMA memory_limit='4GB';
PRAGMA threads=8;
PRAGMA set_progress_bar_time=1;

COPY answers FROM '$users_unique' ( DELIMETER '$tab', QUOTE '', NULL 'NULL', HEADER 0 );
END

echo "Importing ranks"

duckdb $4 <<END
PRAGMA set_progress_bar_time=1;
COPY ranks FROM '$3' ( DELIMETER '$tab', QUOTE '', NULL 'NULL', HEADER 1 );
END
