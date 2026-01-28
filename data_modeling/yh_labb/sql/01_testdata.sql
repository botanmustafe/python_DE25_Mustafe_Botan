--  testdata för att kunna testa FK + M:N och joins
INSERT INTO
    anlaggning (namn)
VALUES
    ('Stockholm'),
    ('Göteborg') ON CONFLICT (namn) DO NOTHING;

INSERT INTO
    program (namn)
VALUES
    ('Data Engineer'),
    ('Frontend Developer') ON CONFLICT (namn) DO NOTHING;

INSERT INTO
    kurs (namn, kurskod, poang, beskrivning)
VALUES
    (
        'Datamodellering',
        'DM101',
        20,
        'Konceptuell, logisk och fysisk modell.'
    ),
    (
        'SQL Grund',
        'SQL100',
        30,
        'SELECT, JOIN och databasgrunder.'
    ),
    (
        'Python Grund',
        'PY100',
        30,
        'Grundläggande programmering.'
    ) ON CONFLICT (kurskod) DO NOTHING;

INSERT INTO
    utbildningsledare (fornamn, efternamn, email)
VALUES
    ('Sara', 'Lind', 'sara.lind@yrkesco.se'),
    ('Omar', 'Ali', 'omar.ali@yrkesco.se') ON CONFLICT (email) DO NOTHING;

INSERT INTO
    utbildare (fornamn, efternamn, email, ar_anstalld)
VALUES
    ('Anna', 'Berg', 'anna.berg@yrkesco.se', TRUE),
    (
        'Erik',
        'Svensson',
        'erik.svensson@yrkesco.se',
        TRUE
    ),
    (
        'Karin',
        'Persson',
        'karin.persson@consult.se',
        FALSE
    ) ON CONFLICT (email) DO NOTHING;

INSERT INTO
    konsultbolag (
        foretagsnamn,
        organisationsnr,
        har_f_skatt,
        adress
    )
VALUES
    (
        'Consult AB',
        '556677-8899',
        TRUE,
        'Konsultgatan 1, Stockholm'
    ) ON CONFLICT (organisationsnr) DO NOTHING;

-- koppla konsult till utbildare + konsultbolag
-- (utbildare_id = 3 är Karin Konsult eftersom vi la in henne som tredje rad)
INSERT INTO
    konsult (utbildare_id, konsultbolag_id, timarvode)
VALUES
    (3, 1, 950.00) ON CONFLICT DO NOTHING;

--  klasser (program + anläggning + utbildningsledare)
INSERT INTO
    klass (program_id, anlaggning_id, utbildningsledare_id)
VALUES
    (1, 1, 1), -- Data Engineer i Stockholm, UL Sara
    (2, 2, 2) ON CONFLICT DO NOTHING;

-- Frontend i Göteborg, UL Omar
-- Studenter
INSERT INTO
    student (klass_id, fornamn, efternamn, email)
VALUES
    (1, 'Musse', 'Botan', 'musse.botan@student.se'),
    (1, 'Lina', 'Nilsson', 'lina.nilsson@student.se'),
    (2, 'Ali', 'Hassan', 'ali.hassan@student.se') ON CONFLICT (email) DO NOTHING;

-- M:N: Program <-> Kurs
-- data engineer innehåller datamodellering + sql
INSERT INTO
    program_kurs (program_id, kurs_id)
VALUES
    (1, 1),
    (1, 2) ON CONFLICT DO NOTHING;

-- frontend innehåller sql + python
INSERT INTO
    program_kurs (program_id, kurs_id)
VALUES
    (2, 2),
    (2, 3) ON CONFLICT DO NOTHING;

-- M:N: Kurs <-> Utbildare
-- datamodellering: Anna + Karin(konsult)
INSERT INTO
    kurs_utbildare (kurs_id, utbildare_id)
VALUES
    (1, 1),
    (1, 3) ON CONFLICT DO NOTHING;

-- SQL: Erik
INSERT INTO
    kurs_utbildare (kurs_id, utbildare_id)
VALUES
    (2, 2) ON CONFLICT DO NOTHING;

-- Python: Karin(konsult)
INSERT INTO
    kurs_utbildare (kurs_id, utbildare_id)
VALUES
    (3, 3) ON CONFLICT DO NOTHING;

-- känsliga uppgifter (separat tabell)
-- koppla personnummer till en student och en utbildningsledare (en i taget per rad)
INSERT INTO
    kansliga_uppgifter (student_id, utbildningsledare_id, personnummer)
VALUES
    (1, NULL, '19930101-1234'),
    (NULL, 1, '19850101-5678') ON CONFLICT (personnummer) DO NOTHING;