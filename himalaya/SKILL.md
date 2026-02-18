---
name: himalaya
description: Email management using Himalaya CLI. Read, send, and manage emails from terminal.
version: 1.0.0
author: Agent Zero Team
tags:
  - email
  - cli
  - terminal
  - mail
  - productivity
trigger_patterns:
  - himalaya
  - email terminal
  - cli email
  - send email terminal
---

# Email Client - Skill Agent Zero

## Rôle
Interface de communication unique pour Agent Zero. Permet d'envoyer et recevoir des emails.

## Outil Utilisé
Script Python : `/a0/usr/workdir/email_client.py`

## Configuration
- **Compte** : `a0@ludoapex.fr`
- **Serveur** : `barrette.o2switch.net` (IMAP: 993, SMTP: 465 SSL)
- **Authentification** : Configurée dans le script Python.

## Règles de Sécurité Critiques 🚨
1. **Destinataires autorisés** :
   - `ludo@ludoapex.fr` (Utilisateur principal)
   - `a0@ludoapex.fr` (Loopback, tests)
   - ⛔ **INTERDICTION STRICTE** d'envoyer à tout autre destinataire.

2. **Contenu** :
   - Ne jamais inclure de secrets (mots de passe, clés API en clair) dans le corps de l'email.
   - Si un rapport contient des données sensibles, chiffrer-les ou les omettre.

## Commandes Disponibles

### Lister les emails
Utilisé pour surveiller les alertes ou la boîte de réception.
```bash
python /a0/usr/workdir/email_client.py list --folder INBOX --limit 20
```

### Lire un email
Utilisé pour récupérer le contenu d'une alerte.
```bash
python /a0/usr/workdir/email_client.py read <id_email>
```

### Envoyer un email (Exemple Python)
À utiliser dans les scripts Python pour éviter les erreurs d'échappement shell.
```python
import subprocess
import sys

recipient = "ludo@ludoapex.fr"
subject = "Rapport Agent Zero"
body = "Contenu du rapport..."

cmd = ['python', '/a0/usr/workdir/email_client.py', 'send', 
        '--to', recipient, 
        '--subject', subject, 
        '--body', body]

try:
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    print(result.stdout)
except subprocess.CalledProcessError as e:
    print(f"Erreur d'envoi: {e.stderr}", file=sys.stderr)
```

## Cas d'Usage
- Rapports de déploiement (Dokploy, etc.).
- Rapports de sécurité (Alertes GitHub/GitGuardian).
- Notifications d'erreurs critiques.
- Rapports de tâches planifiées.
