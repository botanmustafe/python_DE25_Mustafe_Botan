-- orter/anläggningar där klasser bedrivs
CREATE TABLE
    anlaggning (
        anlaggning_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        namn VARCHAR(50) NOT NULL UNIQUE
    );

-- utbildningsprogram (till exempel data engineer)
CREATE TABLE
    program (
        program_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        namn VARCHAR(120) NOT NULL UNIQUE
    );

-- kurser (kan kopplas till program via program_kurs eller var fristående)
CREATE TABLE
    kurs (
        kurs_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        namn VARCHAR(120) NOT NULL,
        kurskod VARCHAR(30) NOT NULL UNIQUE,
        poang INTEGER NOT NULL,
        beskrivning TEXT NOT NULL
    );

-- utbildningsledare 
CREATE TABLE
    utbildningsledare (
        utbildningsledare_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        fornamn VARCHAR(60) NOT NULL,
        efternamn VARCHAR(60) NOT NULL,
        email VARCHAR(120) NOT NULL UNIQUE
    );

-- utbildare
CREATE TABLE
    utbildare (
        utbildare_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        fornamn VARCHAR(60) NOT NULL,
        efternamn VARCHAR(60) NOT NULL,
        email VARCHAR(120) NOT NULL UNIQUE,
        ar_anstalld BOOLEAN NOT NULL DEFAULT FALSE
    );

-- konsultbolag och företagsinfo
CREATE TABLE
    konsultbolag (
        konsultbolag_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        foretagsnamn VARCHAR(140) NOT NULL,
        organisationsnr VARCHAR(20) NOT NULL UNIQUE,
        har_f_skatt BOOLEAN NOT NULL,
        adress VARCHAR(200) NOT NULL
    );

-- konsult (utbildare som är kopplad till konsultbolag + har timarvode)
CREATE TABLE
    konsult (
        konsult_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        utbildare_id INTEGER NOT NULL UNIQUE REFERENCES utbildare (utbildare_id),
        konsultbolag_id INTEGER NOT NULL REFERENCES konsultbolag (konsultbolag_id),
        timarvode NUMERIC(10, 2) NOT NULL
    );

-- klass
CREATE TABLE
    klass (
        klass_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        program_id INTEGER NOT NULL REFERENCES program (program_id),
        anlaggning_id INTEGER NOT NULL REFERENCES anlaggning (anlaggning_id),
        utbildningsledare_id INTEGER NOT NULL REFERENCES utbildningsledare (utbildningsledare_id)
    );

-- student tillhör en klasss
CREATE TABLE
    student (
        student_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        klass_id INTEGER NOT NULL REFERENCES klass (klass_id),
        fornamn VARCHAR(60) NOT NULL,
        efternamn VARCHAR(60) NOT NULL,
        email VARCHAR(120) NOT NULL UNIQUE
    );

-- bryggtabell: program <-> kurs (M:N)
-- en rad = detta program innehåller denna kurs
CREATE TABLE
    program_kurs (
        program_id INTEGER NOT NULL REFERENCES program (program_id),
        kurs_id INTEGER NOT NULL REFERENCES kurs (kurs_id),
        PRIMARY KEY (program_id, kurs_id)
    );

-- bryggtabell: kurs <-> utbildare (M:N)
-- en rad = denna utbildare undervisar denna kurs
CREATE TABLE
    kurs_utbildare (
        kurs_id INTEGER NOT NULL REFERENCES kurs (kurs_id),
        utbildare_id INTEGER NOT NULL REFERENCES utbildare (utbildare_id),
        PRIMARY KEY (kurs_id, utbildare_id)
    );

-- Känsliga personuppgifter i separat tabell 
-- En rad kopplas antingen till en student eller en utbildningsledare
CREATE TABLE
    kansliga_uppgifter (
        kanslig_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        student_id INTEGER UNIQUE REFERENCES student (student_id),
        utbildningsledare_id INTEGER UNIQUE REFERENCES utbildningsledare (utbildningsledare_id),
        personnummer VARCHAR(20) NOT NULL UNIQUE,
        CHECK (
            (
                student_id IS NOT NULL
                AND utbildningsledare_id IS NULL
            )
            OR (
                student_id IS NULL
                AND utbildningsledare_id IS NOT NULL
            )
        )
    );