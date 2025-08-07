# LLM Prompt Vergleichsstudie: Buchempfehlungs-Software QS

## Ihr Original-Prompt
```
wie kann ich QS fälle automatisiert aufsetzten. die software hat folgende funktion
wähle einen autoren aus und die software zeigt die bücher des autors und die meisteverkauften exemplare und tags welche art von buch es ist und empfehlungen darunter. wie teste ich verschiedene fälle.
```

## 1. Empfohlene LLMs für den Vergleich

### Tier 1 LLMs (Empfohlen):
- **ChatGPT (GPT-4)** - OpenAI
- **Claude 3.5 Sonnet** - Anthropic  
- **Gemini Pro** - Google

### Alternative LLMs:
- **Llama 3.1** (Open Source)
- **Mistral Large**
- **Perplexity AI**

## 2. Testfall-Kategorien für Ihre Buchempfehlungs-Software

### A. Funktionale Testfälle
1. **Autor-Suche und -Auswahl**
   - Eindeutige Autoren (z.B. "Stephen King")
   - Mehrdeutige Autoren (z.B. "Michael Smith")
   - Nicht-existente Autoren
   - Autoren mit Sonderzeichen/Umlauten

2. **Buch-Anzeige und Ranking**
   - Autoren mit vielen Büchern (>20)
   - Autoren mit wenigen Büchern (<5)
   - Bücher ohne Verkaufsdaten
   - Bücher mit identischen Verkaufszahlen

3. **Tagging-System**
   - Bücher mit mehreren Genres
   - Bücher ohne Genre-Tags
   - Neue/unbekannte Genres
   - Inkonsistente Tag-Formate

4. **Empfehlungsalgorithmus**
   - Ähnliche Autoren
   - Ähnliche Genres
   - Trending-Bücher
   - Personalisierte Empfehlungen

### B. Edge Cases
- Leere Datenbank
- Netzwerkfehler
- Ungültige Eingaben
- Performance bei großen Datenmengen

### C. User Experience Tests
- Benutzerfreundlichkeit
- Response-Zeit
- Fehlerbehandlung
- Mobile Kompatibilität

## 3. Bewertungskriterien für LLM-Antworten

### Qualitätskriterien (Gewichtung):
1. **Vollständigkeit** (25%)
   - Alle Aspekte der Software abgedeckt
   - Konkrete Testfälle vorgeschlagen
   - Automatisierungsansätze erwähnt

2. **Praktikabilität** (30%)
   - Umsetzbare Vorschläge
   - Realistische Testszenarien
   - Tool-Empfehlungen

3. **Struktur und Klarheit** (20%)
   - Logischer Aufbau
   - Verständliche Sprache
   - Gute Kategorisierung

4. **Technische Tiefe** (25%)
   - Testing-Methoden
   - Automatisierungsstrategien
   - Best Practices

### Bewertungsskala:
- **Exzellent** (9-10): Umfassend, praktisch, gut strukturiert
- **Gut** (7-8): Solide Antwort mit kleineren Lücken
- **Durchschnittlich** (5-6): Grundlegende Abdeckung
- **Schwach** (1-4): Unvollständig oder unpraktisch

## 4. Vorgehen für den Vergleich

### Phase 1: Vorbereitung
1. Accounts bei den 3 gewählten LLMs einrichten
2. Identische Prompt-Formulierung festlegen
3. Bewertungsbogen vorbereiten
4. Zeitstempel für alle Tests dokumentieren

### Phase 2: Durchführung
1. **Gleichzeitige Eingabe**: Prompt binnen 5 Minuten bei allen LLMs eingeben
2. **Dokumentation**: Screenshots und vollständige Antworten speichern
3. **Follow-up Fragen**: Bei Bedarf Nachfragen stellen
4. **Wiederholung**: Test 2-3x zu verschiedenen Zeiten durchführen

### Phase 3: Auswertung
1. Antworten nach Bewertungskriterien bewerten
2. Stärken und Schwächen identifizieren
3. Konsistenz zwischen Durchläufen prüfen
4. Gesamtranking erstellen

## 5. Automatisierung der Tests

### Empfohlene Tools:
- **Selenium/Playwright**: Web-Automatisierung
- **Python**: Scripting und API-Calls
- **Postman**: API-Testing
- **Jest/Cypress**: Frontend-Testing

### Test-Automatisierungs-Framework:
```python
# Beispiel-Struktur
class BookRecommendationTests:
    def test_author_search(self):
        # Autor-Suche testen
        pass
    
    def test_book_ranking(self):
        # Ranking-Funktionalität testen
        pass
    
    def test_tagging_system(self):
        # Tag-System testen
        pass
    
    def test_recommendations(self):
        # Empfehlungen testen
        pass
```

## 6. Konkrete Testdaten-Beispiele

### Testautoren:
- **Stephen King** (viele Bücher, klare Genres)
- **J.K. Rowling** (wenige, aber sehr erfolgreiche Bücher)
- **Agatha Christie** (historische Daten, verschiedene Editionen)
- **Unbekannter Autor** (Edge Case)

### Erwartete Outputs:
- Bücherliste sortiert nach Verkaufszahlen
- Korrekte Genre-Tags
- Relevante Empfehlungen
- Angemessene Response-Zeit (<3 Sekunden)

## 7. Nächste Schritte

1. **LLM-Auswahl finalisieren**
2. **Detaillierte Testfälle ausarbeiten**
3. **Bewertungsbogen erstellen**
4. **Erste Testrunde durchführen**
5. **Ergebnisse analysieren und dokumentieren**