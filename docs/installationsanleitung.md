# Installationsanleitung — Central AI-DOS

Klassifikation: Domäne `documentation`, Komplexität `MEDIUM`, Risiko `LOW`.
Diese Anleitung liegt nur unter `docs/`. Sie ändert weder `governance/`,
`.cursor/rules/` noch `AGENTS.md`. Datensensitivität der Anleitung: `public`.

```text
DECISION: Text auf Deutsch, Dateiname docs/installationsanleitung.md.
  Die bestehende Produktdokumentation (README, governance, orchestration,
  integration) ist Englisch. docs/ war leer und hatte keine Konvention.
  Die Anforderung ist eine deutsche Anleitung. Die englischen Dateien bleiben
  die maßgeblichen Quellen; diese Anleitung verlinkt sie und ersetzt sie nicht.
FACT: Geprüft an dieser Arbeitskopie (Branch main). VERSION enthält 0.1.0.
  Es gibt keinen Anwendungscode, kein Paketmanifest, kein .ai-dos/-Verzeichnis
  und keine Git-Tags. origin dieser Arbeitskopie ist
  https://github.com/nobody1337/AI-Developer-Operating-System.git.
  Binding Decision 1: AI-DOS hängt von keinem Remote ab; ein Remote existiert.
ASSUMPTION: Wer die Central AI-DOS benutzt, öffnet dieses Repository als
  Workspace. Ein Embedded AI-DOS entsteht erst durch den manuellen Ablauf in
  einem anderen Softwareprojekt.
VALIDATION: Dateibaum, VERSION, README, AGENTS.md, integration/README.md,
  integration/initialize.md und integration/update.md wurden gelesen.
  Es wurde kein Cursor-Lauf, kein Build und kein Test ausgeführt.
  Dieses Repository definiert keinen Build und keine Testsuite.
REQUIRES VALIDATION: Ob die jeweilige Cursor-Version AGENTS.md lädt und
  disable-model-invocation an den Skill-Adaptern beachtet. Das steht so auch
  im README unter „What Cursor executes today“.
```

Verwandte Texte: [Handbuch](handbuch.md) (Verzeichnisse, Dateien, Abhängigkeiten),
englische Produktübersicht [README.md](../README.md).

## Zweck

Diese Anleitung beschreibt, wie die **Central AI-DOS** (dieses Repository,
Version in [VERSION](../VERSION)) beschafft, geöffnet und benutzt wird, und
wie daraus ein **Embedded AI-DOS** in einem Softwareprojekt entsteht.

AI-DOS ist Governance, Rollen, Skills, Workflows und Routing für
KI-gestützte Softwareentwicklung. Es ist kein Anwendungsprogramm.
Stand der Quellen: Markdown, YAML und MDC. Kein Orchestrator, keine Pakete.

Statusbegriffe, wie sie [governance/vocabulary.md](../governance/vocabulary.md)
festlegt:

| Begriff | Bedeutung in dieser Version |
|---|---|
| Governance Definition | Regel oder Verfahren, dem Menschen und Agenten folgen. Kein Werkzeug erzwingt es. |
| Actual Automated Orchestration | Was Cursor oder Git von sich aus ausführt (Regeln laden, Ignore-Dateien, Befehle und ausdrücklich aufgerufene Skills anbieten, `.gitignore`). |
| Conceptual | Beschriebenes Format oder beschriebener Ablauf. Nichts im Repository führt ihn aus. |

## Voraussetzungen

| Voraussetzung | Wofür | Belegt in dieser Arbeitskopie |
|---|---|---|
| Git | Klonen und später Versionieren eines Projekts | Repository ist ein Git-Repo. Binding Decision 1 in [governance/README.md](../governance/README.md#1-git) |
| Cursor | Primäre Integrationsschicht | [README.md](../README.md), [AGENTS.md](../AGENTS.md) |
| Schreibrecht im Zielprojekt | Nur für ein Embedded AI-DOS | [integration/initialize.md](../integration/initialize.md) |

Nicht erforderlich für die Central AI-DOS selbst: Node, Python, eine
Laufzeit, ein Paketmanager, ein Build-Tool. In der Arbeitskopie fehlen
`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Makefile` und
`requirements.txt`.

Für Claude Code, OpenAI Codex und GitHub Copilot erzeugt `install.ps1` im
Projekt eigene Adapter (Abschnitt [Welches Werkzeug liest was](#welches-werkzeug-liest-was)).
Für die Installation im Projekt: Windows PowerShell 5.1 oder PowerShell 7.
Ob jedes Werkzeug die Dateien in der eigenen Version wie dokumentiert lädt:
`REQUIRES VALIDATION`.

## Repository beziehen

AI-DOS setzt keinen bestimmten Host voraus. Die geprüfte Arbeitskopie hat
diesen `origin`:

```text
git clone https://github.com/nobody1337/AI-Developer-Operating-System.git
```

[CHANGELOG.md](../CHANGELOG.md) führt `0.1.0` als **unreleased**.
[integration/versioning.md](../integration/versioning.md) sieht Git-Tags
`v<version>` vor, gesetzt von einem Menschen. In dieser Arbeitskopie listet
`git tag` keine Tags. Für ein Embedded AI-DOS ist der Eingang laut
Initialize-Workflow eine freigegebene Version (`VERSION`, Tag sofern vorhanden).
Ohne Tag ist die genaue Quelle ein Commit, den ein Mensch benennt.
`REQUIRES VALIDATION`, sobald ein Tag existiert.

Nach dem Klonen den Ordner in Cursor (oder Claude Code, Codex, VS Code mit
Copilot) als Workspace öffnen. Für den Master selbst gibt es keinen
Installationsbefehl und nichts zu kompilieren. `install.ps1` ist nur für die
Kopie in einem Softwareprojekt gedacht und verweigert im Master den Start.

## Was nach dem Klonen vorliegt

Überblick (vollständig im [Handbuch](handbuch.md)):

```text
/
├── README.md, AGENTS.md, CLAUDE.md, VERSION, CHANGELOG.md
├── install.ps1       Installer für die Projektkopie (.ai-dos/install.ps1)
├── .gitignore, .gitattributes, .editorconfig, .cursorignore
├── .cursor/          rules, commands, skill adapters
├── governance/       maßgebliche Regeln
├── orchestration/    Rollen, Workflows, Routing, Modelle, Zustand (konzeptionell)
├── skills/           werkzeugunabhängige Verfahren
├── templates/        Vorlagen
├── checklists/       Prüflisten
├── integration/      Central → Embedded, Initialize und Update
└── docs/             diese Anleitung und das Handbuch
```

Dieses Repository enthält **kein** `.ai-dos/`. Das ist die Form im
Softwareprojekt, nicht im Master.

## Central AI-DOS in Cursor benutzen

Öffnen des Repositorys genügt. Es wird nichts generiert und nichts gestartet.

Der Mensch bleibt der Orchestrator. Cursor-Regeln und -Befehle sind Hilfen.
So beschreibt es [orchestration/README.md](../orchestration/README.md).

Üblicher Ablauf einer Aufgabe, manuell, Umfang je Risikostufe
([orchestration flow](../orchestration/README.md#orchestration-flow)):

1. Aufgabe klassifizieren (Befehl `/classify-task`).
2. Risiko einordnen. Quelle: [risk-classification.md](../governance/policies/risk-classification.md).
3. Workflow und Rolle wählen.
4. Modell im IDE selbst wählen. AI-DOS liefert eine Capability-Empfehlung,
   schaltet das Modell nicht um. Die Registry enthält nur Einträge mit
   Status `example`; die sind für Routing nicht wählbar
   ([registry.yaml](../orchestration/models/registry.yaml)).
5. Planen, umsetzen, prüfen, berichten. Ab `MEDIUM` Review vor dem Merge;
   ab `HIGH` Planfreigabe; `CRITICAL` und geschützte Aktionen brauchen eine
   ausdrückliche Freigabe vorher
   ([human-approval.md](../governance/policies/human-approval.md)).

Befehle liegen als Markdown unter [`.cursor/commands/`](../.cursor/commands).
Die Dateititel sind `/classify-task`, `/risk-assessment`, `/plan`, `/review`,
`/security-review`, `/new-adr`, `/register-model`, `/request-approval`,
`/handoff`, `/done-check`. Das README bezeichnet sie als angeboten, wenn sie
aufgerufen werden.

## Wie Agenten die Dateien aufnehmen

| Bestandteil | Was die Dateien festlegen | Status |
|---|---|---|
| [AGENTS.md](../AGENTS.md) | Kurzer Einstieg. Die verlinkten Dokumente sind maßgeblich. | Lesen, wo das Werkzeug es unterstützt. `REQUIRES VALIDATION` je Version |
| [CLAUDE.md](../CLAUDE.md) | Einstieg für Claude Code im Master. Importiert `@AGENTS.md` und die vier Always-Regeln, ohne Regeltext zu kopieren | Laut Claude-Code-Dokumentation beim Start geladen. `REQUIRES VALIDATION` am eigenen Rechner |
| [`.cursor/rules/`](../.cursor/rules) | Zusammenfassungen mit Verweis auf die Quelle. Eine Aktivierung je Datei: `alwaysApply`, Globs oder Beschreibung | Actual Automated Orchestration, soweit Cursor Regeln lädt |
| [`.cursor/skills/aidos-*/SKILL.md`](../.cursor/skills) | Dünne Adapter. Verfahren steht in `skills/<name>/SKILL.md`. Frontmatter `disable-model-invocation: true` | Ausdrücklich aufrufen. Automatische Auswahl ist Conceptual (Binding Decision 5). `REQUIRES VALIDATION` für das Flag in der eigenen Cursor-Version |
| [`.cursor/commands/`](../.cursor/commands) | Arbeitsanweisungen, die auf Governance, Skills, Templates und Orchestration verweisen | Anbieten beim Aufruf |
| [`.cursorignore`](../.cursorignore) | Bitte an Cursor, bestimmte Pfade nicht zu indexieren | Best-effort, keine Sicherheitsgrenze. Quelle: Dateikopf und [secrets-and-data.md](../governance/security/secrets-and-data.md) |
| [`.gitignore`](../.gitignore) | Git ignoriert Geheimnisse, Laufzeitdaten, Logs, übliche Build-Ordner | Actual Automated Orchestration durch Git |

Regeln mit `alwaysApply: true`: `00-governance.mdc`, `01-working-method.mdc`,
`04-security.mdc`, `09-ai-safety.mdc`.

Regeln mit Globs (nur passende Dateien): `02-code-quality.mdc` (Quelldateien),
`05-testing.mdc` (Testdateien), `06-dependencies.mdc` (Paketmanifeste).

Regeln mit Beschreibung, `alwaysApply: false`, ohne Globs (agent-requested):
`03-architecture.mdc`, `07-git.mdc`, `08-documentation.mdc`, `10-review.mdc`,
`11-orchestration.mdc`.

Bei Widerspruch zwischen Zusammenfassung und Quelle gilt die Quelle.
Das legt [governance/README.md](../governance/README.md#single-source-of-truth) fest.

Skill-Adapter in diesem Master verweisen auf Pfade ohne `.ai-dos/`-Präfix
(Beispiel: `skills/documentation/SKILL.md`). In einem Projekt tragen
generierte Adapter das Präfix `.ai-dos/`
([path convention](../integration/README.md#path-convention)).

## Embedded AI-DOS in ein Softwareprojekt

Maßgebliche Spezifikation: [integration/initialize.md](../integration/initialize.md).
Status: **teilweise automatisiert**. Der Mensch kopiert den Ordner und startet
`install.ps1`; das Skript erzeugt die Werkzeug-Adapter, Manifest und
Profilgerüst und meldet Konflikte. Analyse, Profilinhalt, Konfliktentscheidungen,
Review und Freigabe bleiben menschliche Schritte. Kein Orchestrator.
Entscheidung: [ADR-002](../governance/decisions/002-multi-tool-adapters.md).

Schreiben von `.ai-dos/`, den Adaptern (`.cursor/`, `.agents/`, `.claude/`,
`.github/`) und der Einstiegsdateien (`AGENTS.md`, `CLAUDE.md`,
`.github/copilot-instructions.md`) im Projekt ist eine Governance-Änderung mit
Risiko `CRITICAL` und braucht eine ausdrückliche menschliche Freigabe
([human-approval.md](../governance/policies/human-approval.md)).
Diese Anleitung ist keine Freigabe.

Zielbild (aus [integration/README.md](../integration/README.md#layout-of-an-embedded-instance)):

```text
<projekt>/
├── AGENTS.md         gemeinsamer Einstieg (Cursor, Codex, Copilot; Claude per Import)
├── CLAUDE.md         Einstieg Claude Code, importiert @AGENTS.md
├── .cursor/          generierte Regeln und Befehle; plus projekteigene Dateien
├── .agents/skills/   generierte Skill-Adapter (Cursor, Codex, Copilot)
├── .claude/          rules/, commands/, settings.json (Claude Code)
├── .github/          copilot-instructions.md, instructions/, prompts/ (Copilot)
└── .ai-dos/          Kopie des Masters inkl. install.ps1, manifest.yaml,
                      project-profile.yaml, workflows/, local/, state/, artifacts/
```

### Schnellstart: Installation mit install.ps1

Voraussetzung: Windows PowerShell 5.1 (in Windows enthalten) oder
PowerShell 7. Keine weiteren Pakete, kein Netzwerkzugriff. Getestet wurde nur
Windows PowerShell 5.1 unter Windows; PowerShell 7 und macOS/Linux sind
`REQUIRES VALIDATION`.

1. **Arbeitsstand sichern.** Im Projekt einen eigenen Branch anlegen
   (`git switch -c chore/ai-dos-install`). Ohne Git vorher ein Backup.
2. **Ordner kopieren — ohne `.git`.** Im Projektwurzelverzeichnis:

   ```text
   robocopy "<pfad-zum-master>" .ai-dos /E /XD .git
   ```

   `robocopy` liefert bei Erfolg Exit-Codes unter 8. Nie `/MIR` verwenden:
   das löscht projekteigene Dateien in `.ai-dos/`. macOS/Linux:
   `rsync -a --exclude .git <master>/ .ai-dos/`.
3. **Probelauf.** `.\.ai-dos\install.ps1 -WhatIf` zeigt, was entstehen würde,
   und schreibt nichts. Blockiert die Ausführungsrichtlinie das Skript:
   `powershell -ExecutionPolicy Bypass -File .\.ai-dos\install.ps1 -WhatIf`
   (gilt nur für diesen einen Aufruf).
4. **Installieren.** `.\.ai-dos\install.ps1`. Die Zusammenfassung listet
   `created`, `inserted`, `unchanged`, `conflict`, `action` usw. Ein zweiter
   Lauf ändert nichts (idempotent).
5. **Konflikte entscheiden.** `conflict` heißt: Datei gleichen Namens ohne
   AI-DOS-Marker oder seit der Erzeugung verändert. Das Skript fasst sie nicht
   an. Entweder behalten (bei generierten Dateien in
   `integration.local_modifications` des Manifests eintragen) oder die Datei
   bzw. den Block samt Markern löschen und das Skript erneut starten.
6. **`.cursorignore` selbst anlegen** aus `.ai-dos/templates/cursorignore.template`
   (das Skript erinnert nur daran, es legt die Datei nie an).
7. **Projektteile ausfüllen** (siehe nächster Abschnitt) und
   `.ai-dos/project-profile.yaml` befüllen (Projekt, Technik, `tooling`,
   `security`). `ai_dos.source.ref` im Manifest setzen, falls bekannt.
8. **Prüfen und committen.** `git diff` lesen, Integrationsprüfung (unten),
   Review, Freigabe, Merge durch den Menschen.

### Einstiegsdateien projektspezifisch erweitern

`AGENTS.md`, `CLAUDE.md` und `.github/copilot-instructions.md` entstehen aus
den Vorlagen [project-agents.md](../templates/project-agents.md),
[project-claude.md](../templates/project-claude.md) und
[project-copilot-instructions.md](../templates/project-copilot-instructions.md).
Jede Datei hat zwei Teile:

- **Projektteil** (alles außerhalb der Marker): gehört dem Projekt. Hier
  stehen Projektbeschreibung, Module, eigene Regeln. Das Skript überschreibt
  ihn nie. Gemeinsame Anweisungen für alle Werkzeuge gehören in `AGENTS.md`;
  `CLAUDE.md` und `copilot-instructions.md` nur für werkzeugspezifische Zusätze.
- **AI-DOS-Block** zwischen `<!-- ai-dos:begin (generated; do not edit) -->`
  und `<!-- ai-dos:end -->`: wird generiert, trägt eine Hash-Zeile und wird
  nur mit `-Update` ersetzt — und nur, wenn niemand ihn verändert hat.

Bestehende Dateien bleiben erhalten; das Skript hängt nur den Block an.

### Welches Werkzeug liest was

| Werkzeug | Liest | Erreicht die Regeln über | Skills / Befehle |
|---|---|---|---|
| Cursor | `.cursor/rules/*.mdc`, `AGENTS.md` | Regeln nativ (always / Globs / Beschreibung) und `AGENTS.md`-Block | `/aidos-<skill>` aus `.agents/skills/`, `/<befehl>` aus `.cursor/commands/` |
| Claude Code | `CLAUDE.md` | Block importiert `@AGENTS.md`; Glob-Regeln als `.claude/rules/aidos-*.md` | `/aidos-<name>` aus `.claude/commands/` (nur explizit) |
| OpenAI Codex | `AGENTS.md` | Block enthält die Always-Regeln und die Liste der bedingten Regeldateien | `$aidos-<skill>` aus `.agents/skills/` (nur explizit); Befehle: Codex bitten, `.cursor/commands/<befehl>.md` zu befolgen |
| GitHub Copilot | `.github/copilot-instructions.md`, auf Agent-Oberflächen auch `AGENTS.md` | Block wiederholt die generierten Regelabschnitte (Copilot kann nicht importieren); Glob-Regeln als `.github/instructions/aidos-*.instructions.md` | `/aidos-<befehl>` aus `.github/prompts/`; Skills aus `.agents/skills/` (ob Copilot sie nur explizit nutzt: `REQUIRES VALIDATION`) |

Die Tabelle beruht auf der offiziellen Dokumentation der Werkzeuge
(gelesen am 2026-11-01), nicht auf einem Lauf in jedem Werkzeug:
`REQUIRES VALIDATION` am eigenen Projekt. Die Kopien `.ai-dos/AGENTS.md`,
`.ai-dos/CLAUDE.md` und `.ai-dos/.cursor/` sind inaktive Generatorquellen
([inactive master copies](../integration/README.md#inactive-master-copies)).

Das Projekt arbeitet danach ohne Zugriff auf dieses Repository.
Der Master wird für neue Projekte, Updates, Vorlagen und die Weiterentwicklung
von AI-DOS gebraucht.

### Schritte (Initialize)

Die folgende Liste gibt die Schrittfolge aus `integration/initialize.md` wieder.
Weicht sie von jener Datei ab, gilt die Datei. Die Schritte 8 (Verzeichnisse)
bis 12 führt `install.ps1` aus; die Liste beschreibt, was dabei geschieht.

1. Projekt nur lesend analysieren. Projektskripte nicht ausführen.
2. Sprache und Framework aus Manifesten lesen. Unbekannt bleibt `unknown`.
3. Build-, Test- und Lint-Befehle aus Manifesten und CI lesen. Ungeprüft:
   `REQUIRES VALIDATION`.
4. Repository-Struktur erkennen (Module, Default-Branch, vorhandene ADRs).
5. Datensensitivität und Einschränkungen vorschlagen. Der Mensch entscheidet.
6. [templates/project-profile.yaml](../templates/project-profile.yaml) nach
   `.ai-dos/project-profile.yaml` füllen.
7. Skills, Workflows, erlaubte Rollen und Modelle im Profil auswählen.
   Die verwalteten Kopien bleiben vollständig. Die Auswahl steuert generierte
   Adapter und Einschränkungen im Profil.
8. `.ai-dos/` anlegen: den ganzen Master ohne `.git` kopieren (Mensch).
   `workflows/`, `local/rules/`, `local/skills/`, `state/tasks/`, `artifacts/`
   legt das Skript an.
9. `.cursor/rules/` aus den Master-Regeln `00`–`11` erzeugen. Jeden
   AI-DOS-Wurzelpfad mit `.ai-dos/` präfixieren. Glob-Regeln zusätzlich als
   `.claude/rules/` und `.github/instructions/`. Die Ableitung der Globs von
   `02`, `05` und `06` aus `technology.languages` ist **nicht automatisiert**
   (eingeengte Globs als `local_modifications` deklarieren). Vorhandene
   Projektregeln behalten. Namenskonflikte sind Konflikte, kein stilles
   Überschreiben.
10. Skill-Adapter `aidos-<skill>` nur für aktivierte Skills erzeugen, in
    `.agents/skills/` (Cursor, Codex, Copilot) und `.claude/commands/`;
    nur explizit aufrufbar. Befehle nach `.cursor/commands/`,
    `.claude/commands/aidos-*` und `.github/prompts/aidos-*`.
11. `AGENTS.md`, `CLAUDE.md` und `.github/copilot-instructions.md` aus den
    Vorlagen. Eine vorhandene Datei bleibt erhalten; der AI-DOS-Block kommt
    zwischen die Marker.
12. [templates/manifest.yaml](../templates/manifest.yaml) nach
    `.ai-dos/manifest.yaml` (nur falls fehlend). Den AI-DOS-Block aus
    [templates/project-gitignore.template](../templates/project-gitignore.template)
    in `.gitignore` einfügen. Den Menschen bitten, `.cursorignore` aus
    [templates/cursorignore.template](../templates/cursorignore.template)
    anzulegen. Agenten legen `.cursorignore` nicht selbst an (Dateikopf der
    Vorlage; Cursor schützt die Datei).
13. Integrationsprüfung (unten).
14. Implementation Report und Approval Record unter
    `.ai-dos/artifacts/updates/<datum>-initialize/`.

Vorhandene Projektdateien werden nicht überschrieben. Konflikte entscheidet
der Mensch nach [integration/update.md](../integration/update.md#conflict-mechanism).

Schema für Manifest und Profil, ohne Validator im Repository:
[manifest.schema.yaml](../integration/manifest.schema.yaml),
[project-profile.schema.yaml](../integration/project-profile.schema.yaml).
`features.orchestration`, `features.automated_routing` und
`features.automated_skill_selection` sind im Schema für 0.x `false`.

### Integrationsprüfung

Aus [initialize.md](../integration/initialize.md#integration-check). Nicht
geprüfte Punkte als `not_run` berichten:

- Jeder Pfad, auf den generierte `.cursor/`-Dateien und `AGENTS.md` zeigen,
  existiert im Projekt.
- Kein absoluter Pfad, kein Verweis auf den Speicherort des Masters, kein
  Verweis nach außerhalb des Projekts.
- Relative Links innerhalb `.ai-dos/` lösen innerhalb `.ai-dos/` auf.
- `manifest.yaml` und `project-profile.yaml` sind YAML gemäß Schema und
  enthalten keine Geheimnisse.
- Die Always-Regeln `00`, `01`, `04`, `09` sind vorhanden und außer den
  Pfadpräfixen unverändert.
- Verwaltete Kopien entsprechen der Quellversion.
- `features.*` sind sämtlich `false`.

### Späteres Update

[integration/update.md](../integration/update.md) ist **teilweise
automatisiert** und `CRITICAL`. Ein Update überschreibt lokale Projektregeln
nicht still. Ablauf auf einem eigenen Branch:

```text
robocopy "<pfad-zum-master>" .ai-dos /E /XD .git
.\.ai-dos\install.ps1 -Update -WhatIf
.\.ai-dos\install.ps1 -Update
git diff
```

Generierte Dateien und Blöcke ersetzt das Skript nur, wenn ihr Inhalt noch
zum gespeicherten Hash passt; sonst `conflict`. Die verwalteten Kopien in
`.ai-dos/` überschreibt der Kopierschritt ohne Drei-Wege-Vergleich — deshalb
`git diff` vor dem Merge lesen. Im Master gelöschte Dateien bleiben nach dem
Kopieren liegen und werden per Entscheidung entfernt. Rollback ist eine
menschliche Aktion über die Versionsverwaltung oder ein zuvor angelegtes Backup.
Versionsschema: [integration/versioning.md](../integration/versioning.md).

## Prüfen, dass die Central AI-DOS benutzbar ist

Es gibt keine `npm test`-, Build- oder Lint-Skripte. Eine grüne Pipeline ist
für dieses Repository nicht definiert.

Sinnvolle manuelle Prüfung nach dem Öffnen:

| Prüfung | Erwartung | Wie belegt |
|---|---|---|
| [VERSION](../VERSION) | `0.1.0` | Dateiinhalt dieser Arbeitskopie |
| [AGENTS.md](../AGENTS.md) im Workspace sichtbar | Einstieg verlinkt `governance/`, `orchestration/`, `skills/` | Datei vorhanden |
| Always-Regeln vorhanden | vier Dateien mit `alwaysApply: true` | Frontmatter gelesen |
| Skill-Adapter | elf Verzeichnisse `aidos-*`, jedes mit `disable-model-invocation: true` | Dateien gelesen |
| Kein Orchestrator | [future-orchestrator.md](../orchestration/future-orchestrator.md) Status Conceptual, not implemented | Dateikopf |

Ob Cursor die Regeln in der eigenen Version tatsächlich lädt:
`REQUIRES VALIDATION` am eigenen Workspace.

## Was nicht automatisiert ist

| Thema | Status |
|---|---|
| Governance, Rollen, Workflows, Skills, Checklisten, Templates | Governance Definition |
| Risikostufen, Freigaben, Quality Gates | Governance Definition. Durchsetzung nur über externe Mittel (Branch Protection, CI, Berechtigungen), die dieses Repository nicht mitliefert |
| Modellregistry und Routing | Daten (nur `example`) und manuelle Empfehlung. Der Mensch wählt das Modell |
| Manifest, Projektprofil, Dateiklassen, Pfadkonvention | Governance Definition. Kein Werkzeug parst sie |
| Initialize und Update | Teilweise automatisiert: `install.ps1` erzeugt Adapter, Manifest und Profilgerüst und erkennt Konflikte per Hash. Kopieren, Analyse, Entscheidungen, Review manuell |
| Task State, Audit, Context Packages | Conceptual. Manuell nutzbar |
| Orchestrator, automatische Skill-Auswahl, Drei-Wege-Vergleich verwalteter Kopien, Schema-Validatoren | Conceptual. Kein Code. [future-orchestrator.md](../orchestration/future-orchestrator.md) |

Dieselbe Dreiteilung steht auf Englisch im
[README](../README.md#what-cursor-executes-today-vs-convention-vs-future-automation)
und in [integration/README.md](../integration/README.md#what-cursor-executes-today-vs-convention-vs-future-automation).

## Lizenz

[README.md](../README.md#license) und Binding Decision 7: nicht zur
Weiterverteilung lizenziert. Öffentliches Hosting ist keine Lizenz.

## Siehe auch

- [Handbuch](handbuch.md)
- [README.md](../README.md)
- [AGENTS.md](../AGENTS.md)
- [integration/README.md](../integration/README.md)
