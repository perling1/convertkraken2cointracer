#!/usr/bin/env python3
"""
LLM Prompt Vergleichsscript für Buchempfehlungs-Software QS
Automatisiert die Durchführung und Bewertung von LLM-Tests
"""

import json
import time
import datetime
from typing import Dict, List, Any
from dataclasses import dataclass
import csv

@dataclass
class LLMResponse:
    """Datenklasse für LLM-Antworten"""
    llm_name: str
    prompt: str
    response: str
    timestamp: str
    response_time: float
    
@dataclass
class EvaluationCriteria:
    """Bewertungskriterien für LLM-Antworten"""
    completeness: int  # 1-10
    practicality: int  # 1-10
    structure_clarity: int  # 1-10
    technical_depth: int  # 1-10
    
    def weighted_score(self) -> float:
        """Berechnet gewichteten Gesamtscore"""
        return (
            self.completeness * 0.25 +
            self.practicality * 0.30 +
            self.structure_clarity * 0.20 +
            self.technical_depth * 0.25
        )

class LLMComparison:
    """Hauptklasse für LLM-Vergleichstests"""
    
    def __init__(self):
        self.test_prompt = """wie kann ich QS fälle automatisiert aufsetzten. die software hat folgende funktion
wähle einen autoren aus und die software zeigt die bücher des autors und die meisteverkauften exemplare und tags welche art von buch es ist und empfehlungen darunter. wie teste ich verschiedene fälle."""
        
        self.llm_configs = {
            "ChatGPT": {
                "url": "https://api.openai.com/v1/chat/completions",
                "headers": {"Authorization": "Bearer YOUR_API_KEY"},
                "model": "gpt-4"
            },
            "Claude": {
                "url": "https://api.anthropic.com/v1/messages",
                "headers": {"x-api-key": "YOUR_API_KEY"},
                "model": "claude-3-5-sonnet-20241022"
            },
            "Gemini": {
                "url": "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
                "headers": {"Authorization": "Bearer YOUR_API_KEY"},
                "model": "gemini-pro"
            }
        }
        
        self.test_cases = self._define_test_cases()
        self.responses: List[LLMResponse] = []
        
    def _define_test_cases(self) -> Dict[str, Any]:
        """Definiert konkrete Testfälle für die Buchempfehlungs-Software"""
        return {
            "functional_tests": {
                "author_search": [
                    "Stephen King",
                    "Michael Smith",  # Mehrdeutig
                    "XYZ Unknown Author",  # Nicht existent
                    "José Saramago"  # Sonderzeichen
                ],
                "book_display": [
                    "Autor mit >20 Büchern",
                    "Autor mit <5 Büchern",
                    "Bücher ohne Verkaufsdaten",
                    "Identische Verkaufszahlen"
                ],
                "tagging_system": [
                    "Multiple Genres",
                    "Keine Genre-Tags",
                    "Neue Genres",
                    "Inkonsistente Formate"
                ],
                "recommendations": [
                    "Ähnliche Autoren",
                    "Ähnliche Genres",
                    "Trending-Bücher",
                    "Personalisierte Empfehlungen"
                ]
            },
            "edge_cases": [
                "Leere Datenbank",
                "Netzwerkfehler",
                "Ungültige Eingaben",
                "Performance-Tests"
            ],
            "ux_tests": [
                "Benutzerfreundlichkeit",
                "Response-Zeit",
                "Fehlerbehandlung",
                "Mobile Kompatibilität"
            ]
        }
    
    def simulate_llm_call(self, llm_name: str, prompt: str) -> LLMResponse:
        """
        Simuliert einen LLM-API-Call
        In der Praxis würden hier echte API-Calls gemacht
        """
        start_time = time.time()
        
        # Simulation verschiedener Antwortqualitäten
        simulated_responses = {
            "ChatGPT": """Für die automatisierte QS Ihrer Buchempfehlungs-Software empfehle ich folgendes Vorgehen:

1. **Funktionale Tests:**
   - Autor-Suche: Testen Sie eindeutige Namen (Stephen King), mehrdeutige (Michael Smith) und nicht-existente Autoren
   - Buch-Display: Prüfen Sie Sortierung nach Verkaufszahlen, korrekte Anzeige von Metadaten
   - Tagging: Validieren Sie Genre-Zuordnungen und Tag-Konsistenz
   - Empfehlungen: Testen Sie Algorithmus-Logik für ähnliche Autoren/Genres

2. **Automatisierung:**
   - Selenium für UI-Tests
   - API-Testing mit Postman/Newman
   - Kontinuierliche Integration mit Jenkins/GitHub Actions
   - Testdaten-Management mit Fixtures

3. **Edge Cases:**
   - Leere Suchergebnisse
   - Netzwerkfehler-Simulation
   - Performance unter Last
   - Fehlerbehandlung

4. **Tools:**
   - pytest für Python-Tests
   - Cypress für End-to-End Tests
   - Docker für konsistente Testumgebungen""",
            
            "Claude": """Hier ist eine strukturierte Herangehensweise für automatisierte QS-Tests Ihrer Buchempfehlungs-Software:

**Test-Kategorien:**

A) **Autor-Funktionalität**
   - Eindeutige Autoren: Stephen King, J.K. Rowling
   - Mehrdeutige Namen: Michael Smith, John Williams
   - Sonderzeichen: José Saramago, Björk Guðmundsdóttir
   - Nicht-existente Autoren

B) **Buch-Ranking & Display**
   - Verkaufszahlen-Sortierung
   - Metadaten-Vollständigkeit
   - Tag-Zuordnung (Horror, Fantasy, etc.)
   - Empfehlungs-Relevanz

C) **Automatisierung-Framework**
   - Page Object Model für UI-Tests
   - API-Test-Suite für Backend
   - Datenbank-Tests für Konsistenz
   - Performance-Monitoring

**Implementierung:**
- Testpyramide: Unit > Integration > E2E
- CI/CD-Pipeline mit automatischen Regressionstests
- Monitoring und Alerting
- A/B-Testing für Empfehlungsalgorithmen""",
            
            "Gemini": """QS-Automatisierung für Buchempfehlungs-Software:

**1. Testfälle definieren:**
- Autor-Suche (bekannte/unbekannte Autoren)
- Buchauflistung nach Verkaufszahlen
- Genre-Tagging Korrektheit
- Empfehlungsalgorithmus

**2. Automatisierung:**
- Selenium WebDriver für Browser-Tests
- REST API Testing
- Datenbank-Validierung
- Performance-Tests

**3. Test-Szenarien:**
- Happy Path: Erfolgreiche Autor-Suche → Buchliste → Empfehlungen
- Error Cases: Ungültige Eingaben, Server-Fehler
- Edge Cases: Leere Ergebnisse, Timeout

**4. Tools:**
- TestNG/JUnit für Java
- pytest für Python
- Newman für API-Tests
- JMeter für Load-Tests

**5. Continuous Testing:**
- Jenkins Pipeline
- Automated Regression Suite
- Test Reports und Metriken"""
        }
        
        response_time = time.time() - start_time
        
        return LLMResponse(
            llm_name=llm_name,
            prompt=prompt,
            response=simulated_responses.get(llm_name, "Keine Antwort verfügbar"),
            timestamp=datetime.datetime.now().isoformat(),
            response_time=response_time
        )
    
    def run_comparison(self) -> List[LLMResponse]:
        """Führt Vergleichstests mit allen konfigurierten LLMs durch"""
        print("Starte LLM-Vergleichstests...")
        
        for llm_name in self.llm_configs.keys():
            print(f"Teste {llm_name}...")
            response = self.simulate_llm_call(llm_name, self.test_prompt)
            self.responses.append(response)
            time.sleep(1)  # Rate limiting
        
        return self.responses
    
    def evaluate_response(self, response: LLMResponse) -> EvaluationCriteria:
        """
        Bewertet eine LLM-Antwort nach definierten Kriterien
        In der Praxis könnte hier auch ein anderes LLM zur Bewertung eingesetzt werden
        """
        # Simulierte Bewertungen basierend auf Antwortlänge und Schlüsselwörtern
        text = response.response.lower()
        
        # Vollständigkeit (25%)
        completeness_keywords = ["autor", "buch", "test", "automatisierung", "empfehlung"]
        completeness = min(10, sum(2 for kw in completeness_keywords if kw in text))
        
        # Praktikabilität (30%)
        practicality_keywords = ["selenium", "api", "pytest", "tool", "framework"]
        practicality = min(10, sum(2 for kw in practicality_keywords if kw in text))
        
        # Struktur und Klarheit (20%)
        structure_indicators = text.count('\n') + text.count('**') + text.count('-')
        structure_clarity = min(10, structure_indicators // 5 + 5)
        
        # Technische Tiefe (25%)
        technical_keywords = ["integration", "performance", "database", "pipeline", "monitoring"]
        technical_depth = min(10, sum(2 for kw in technical_keywords if kw in text))
        
        return EvaluationCriteria(
            completeness=completeness,
            practicality=practicality,
            structure_clarity=structure_clarity,
            technical_depth=technical_depth
        )
    
    def generate_report(self) -> Dict[str, Any]:
        """Generiert detaillierten Vergleichsbericht"""
        report = {
            "test_info": {
                "prompt": self.test_prompt,
                "timestamp": datetime.datetime.now().isoformat(),
                "llm_count": len(self.responses)
            },
            "results": []
        }
        
        for response in self.responses:
            evaluation = self.evaluate_response(response)
            
            result = {
                "llm_name": response.llm_name,
                "response_time": response.response_time,
                "evaluation": {
                    "completeness": evaluation.completeness,
                    "practicality": evaluation.practicality,
                    "structure_clarity": evaluation.structure_clarity,
                    "technical_depth": evaluation.technical_depth,
                    "weighted_score": evaluation.weighted_score()
                },
                "response_preview": response.response[:200] + "..."
            }
            report["results"].append(result)
        
        # Ranking erstellen
        report["results"].sort(key=lambda x: x["evaluation"]["weighted_score"], reverse=True)
        
        return report
    
    def save_results(self, report: Dict[str, Any], filename: str = None):
        """Speichert Ergebnisse in JSON und CSV"""
        if not filename:
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"llm_comparison_{timestamp}"
        
        # JSON-Report speichern
        with open(f"{filename}.json", "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        
        # CSV-Summary speichern
        with open(f"{filename}_summary.csv", "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["LLM", "Vollständigkeit", "Praktikabilität", "Struktur", "Technische Tiefe", "Gesamtscore"])
            
            for result in report["results"]:
                eval_data = result["evaluation"]
                writer.writerow([
                    result["llm_name"],
                    eval_data["completeness"],
                    eval_data["practicality"],
                    eval_data["structure_clarity"],
                    eval_data["technical_depth"],
                    f"{eval_data['weighted_score']:.2f}"
                ])
        
        print(f"Ergebnisse gespeichert: {filename}.json und {filename}_summary.csv")

def main():
    """Hauptfunktion für Script-Ausführung"""
    print("=== LLM Prompt Vergleichsstudie ===")
    print("Buchempfehlungs-Software QS Testing\n")
    
    # Vergleich durchführen
    comparison = LLMComparison()
    responses = comparison.run_comparison()
    
    # Bericht generieren
    report = comparison.generate_report()
    
    # Ergebnisse anzeigen
    print("\n=== ERGEBNISSE ===")
    for i, result in enumerate(report["results"], 1):
        print(f"{i}. {result['llm_name']}")
        print(f"   Gesamtscore: {result['evaluation']['weighted_score']:.2f}/10")
        print(f"   Vollständigkeit: {result['evaluation']['completeness']}/10")
        print(f"   Praktikabilität: {result['evaluation']['practicality']}/10")
        print(f"   Struktur: {result['evaluation']['structure_clarity']}/10")
        print(f"   Technische Tiefe: {result['evaluation']['technical_depth']}/10")
        print()
    
    # Ergebnisse speichern
    comparison.save_results(report)
    
    print("Vergleichsstudie abgeschlossen!")

if __name__ == "__main__":
    main()