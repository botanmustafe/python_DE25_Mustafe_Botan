-- enkla queries som visar att relationer och M:N fungerar
-- alla studenter + vilken klass, vilket program och vilken ort de tillhör
SELECT
    s.student_id,
    s.fornamn,
    s.efternamn,
    k.klass_id,
    p.namn AS program,
    a.namn AS anlaggning
FROM
    student s
    JOIN klass k ON s.klass_id = k.klass_id
    JOIN program p ON k.program_id = p.program_id
    JOIN anlaggning a ON k.anlaggning_id = a.anlaggning_id
ORDER BY
    s.student_id;

-- vilken utbildningsledare ansvarar för vilken klass (och program)
SELECT
    k.klass_id,
    p.namn AS program,
    ul.fornamn,
    ul.efternamn
FROM
    klass k
    JOIN program p ON k.program_id = p.program_id
    JOIN utbildningsledare ul ON k.utbildningsledare_id = ul.utbildningsledare_id
ORDER BY
    k.klass_id;

-- vilka kurser ingår i respektive program (M:N via program_kurs)
SELECT
    p.namn AS program,
    ku.namn AS kurs,
    ku.kurskod,
    ku.poang
FROM
    program p
    JOIN program_kurs pk ON p.program_id = pk.program_id
    JOIN kurs ku ON pk.kurs_id = ku.kurs_id
ORDER BY
    p.namn,
    ku.namn;

-- vilka utbildare undervisar vilka kurser (M:N via kurs_utbildare)
SELECT
    ku.namn AS kurs,
    u.fornamn,
    u.efternamn,
    u.email
FROM
    kurs ku
    JOIN kurs_utbildare ku_u ON ku.kurs_id = ku_u.kurs_id
    JOIN utbildare u ON ku_u.utbildare_id = u.utbildare_id
ORDER BY
    ku.namn,
    u.efternamn;

-- vilka utbildare är konsulter + vilket bolag + timarvode
SELECT
    u.fornamn,
    u.efternamn,
    kb.foretagsnamn,
    k.timarvode
FROM
    konsult k
    JOIN utbildare u ON k.utbildare_id = u.utbildare_id
    JOIN konsultbolag kb ON k.konsultbolag_id = kb.konsultbolag_id
ORDER BY
    kb.foretagsnamn,
    u.efternamn;

-- visa känsliga uppgifter (separat) och vem de tillhör
-- (vi visar bara kopplingarna, inte allt annat)
SELECT
    ku.kanslig_id,
    ku.personnummer,
    ku.student_id,
    ku.utbildningsledare_id
FROM
    kansliga_uppgifter ku
ORDER BY
    ku.kanslig_id;