---
name: "himalaya"
description: "CLI email client pour gérer les emails via IMAP/SMTP. Permet de lister, lire, écrire, répondre, transférer et organiser les emails depuis le terminal. Configurez l'adresse a0@ludoapex.fr pour Agent Zero."
version: "1.1.0"
author: "Agent Zero Team"
tags: ["email", "cli", "imap", "smtp", "communication", "notifications"]
trigger_patterns:
  - "email"
  - "envoyer email"
  - "lire email"
  - "himalaya"
  - "a0@ludoapex.fr"
---

# Himalaya - Email Client pour Agent Zero

## When to Use
Activez ce skill quand :
- Vous devez envoyer un email depuis `a0@ludoapex.fr`
- Vous devez lire les emails de `a0@ludoapex.fr`
- Vous devez configurer l'adresse email pour Agent Zero
- Vous devez créer des rapports ou notifications par email
- Une tâche planifiée doit envoyer des rapports

## Configuration Actuelle

### Adresse Email Agent Zero
- **Email**: `a0@ludoapex.fr`
- **Hébergeur**: o2switch

### Configuration IMAP (Réception)
- **Serveur**: `barrette.o2switch.net`
- **Port**: `993`
- **Sécurité**: SSL/TLS

### Configuration SMTP (Envoi)
- **Serveur**: `barrette.o2switch.net`
- **Port**: `465`
- **Sécurité**: SSL/TLS

## Client Email Python (Alternative à Himalaya CLI)

Himalaya CLI n'a pas pu être installé dans le conteneur Docker (problème de compatibilité Rust webpki). Un script Python alternatif a été créé.

### Emplacement du Script
`/a0/usr/workdir/email_client.py`

### Commandes Disponibles

#### Envoyer un email
```bash
python /a0/usr/workdir/email_client.py send --to <destinataire> --subject "<sujet>" --body "<message>"
```

#### Lister les emails
```bash
python /a0/usr/workdir/email_client.py list --folder INBOX --limit 10
```

#### Lire un email
```bash
python /a0/usr/workdir/email_client.py read <id_email>
```

### Exemples d'Utilisation

#### Envoyer un email simple
```python
import subprocess
import json

result = subprocess.run([
    'python', '/a0/usr/workdir/email_client.py', 'send',
    '--to', 'ludo@ludoapex.fr',
    '--subject', 'Rapport Journalier',
    '--body', 'Voici le rapport...'
], capture_output=True, text=True)

response = json.loads(result.stdout)
if response['success']:
    print('Email envoyé avec succès!')
else:
    print(f'Erreur: {response["error"]}')
```

#### Envoyer un email avec HTML
```python
import subprocess

html_body = '''
<h1>Rapport Journalier</h1>
<ul>
    <li>Total mémoires: 100</li>
    <li>Supprimées: 2</li>
</ul>
'''

subprocess.run([
    'python', '/a0/usr/workdir/email_client.py', 'send',
    '--to', 'ludo@ludoapex.fr',
    '--subject', 'Rapport Journalier',
    '--body', 'Version texte du rapport',
    '--html', html_body
], capture_output=True, text=True)
```

#### Lister les emails
```python
import subprocess
import json

result = subprocess.run([
    'python', '/a0/usr/workdir/email_client.py', 'list',
    '--folder', 'INBOX',
    '--limit', '10'
], capture_output=True, text=True)

response = json.loads(result.stdout)
if response['success']:
    for email in response['emails']:
        print(f"De: {email['from']}")
        print(f"Sujet: {email['subject']}")
        print(f"Date: {email['date']}")
        print('---')
```

## Cas d'Usage pour Agent Zero

### 1. Rapport Quotidien (Memory Optimizer)

```python
import subprocess

def send_daily_report(stats):
    subject = "📊 Rapport Memory Optimizer"
    body = f"""
📅 Date: {stats['date']}
Total mémoires analysées : {stats['total']}
Mémoires supprimées : {stats['deleted']}
Mémoires conservées : {stats['kept']}
Réduction obtenue : {stats['reduction']}%

Recommandations :
{stats['recommendations']}
"""
    
    subprocess.run([
        'python', '/a0/usr/workdir/email_client.py', 'send',
        '--to', 'ludo@ludoapex.fr',
        '--subject', subject,
        '--body', body
    ], capture_output=True, text=True)

# Utilisation
send_daily_report({
    'date': '2026-02-12',
    'total': 100,
    'deleted': 2,
    'kept': 98,
    'reduction': '36',
    'recommendations': 'Aucune recommandation aujourd\'hui.'
})
```

### 2. Notification d'Alerte

```python
import subprocess

def send_alert(title, message, alert_type='warning'):
    icon = '⚠️' if alert_type == 'warning' else 'ℹ️'
    subject = f"{icon} {title}"
    
    subprocess.run([
        'python', '/a0/usr/workdir/email_client.py', 'send',
        '--to', 'ludo@ludoapex.fr',
        '--subject', subject,
        '--body', message
    ], capture_output=True, text=True)

# Utilisation
send_alert(
    "Action Requise",
    "3 mémoires identifiées pour suppression mais nécessitent confirmation.",
    alert_type='warning'
)
```

### 3. Lecture et Traitement des Emails

```python
import subprocess
import json

def process_inbox():
    result = subprocess.run([
        'python', '/a0/usr/workdir/email_client.py', 'list',
        '--folder', 'INBOX',
        '--limit', '20'
    ], capture_output=True, text=True)
    
    response = json.loads(result.stdout)
    if response['success']:
        for email in response['emails']:
            print(f"Traitement email de {email['from']}")
            # Logique de traitement...

process_inbox()
```

## Configuration du Script email_client.py

Le script `/a0/usr/workdir/email_client.py` contient la configuration directe de l'email.

Pour modifier la configuration, éditez le fichier et modifiez la section `EMAIL_CONFIG` :

```python
EMAIL_CONFIG = {
    'email': 'a0@ludoapex.fr',
    'password': 'p#mGo!#WeiA2',
    'imap_server': 'barrette.o2switch.net',
    'imap_port': 993,
    'smtp_server': 'barrette.o2switch.net',
    'smtp_port': 465,
}
```

## Notes sur l'Installation de Himalaya

### Pourquoi Himalaya n'est pas installé ?

L'installation de Himalaya via `cargo install himalaya` a échoué dans le conteneur Docker à cause d'un problème de compatibilité Rust (webpki::Error).

### Alternatives Possibles

1. **Script Python actuel** (recommandé) : `/a0/usr/workdir/email_client.py`
2. **Installer Himalaya via binaire précompilé** : Échoué (fichier corrompu)
3. **Installer Rust et recompiler** : Trop long et complexe
4. **Utiliser un autre client email** : Non nécessaire, le script Python est suffisant

### Avantages du Script Python
- ✅ Fonctionne dans le conteneur Docker actuel
- ✅ Authentification SMTP réussie (port 465 SSL)
- ✅ Commandes simples (send, list, read)
- ✅ Sortie JSON pour l'automatisation
- ✅ Intégration facile avec Agent Zero

## Troubleshooting

### Erreur (535, b'Incorrect authentication data')
Vérifiez que le mot de passe dans `EMAIL_CONFIG` est correct.

### Erreur (550, b'No Such User Here')
L'adresse email du destinataire n'existe pas sur le serveur. Vérifiez l'adresse email correcte.

### Erreur de connexion IMAP
Vérifiez que le serveur IMAP `barrette.o2switch.net` et le port 993 sont corrects.

## Integration with Agent Zero Scheduler

### Tâche Planifiée Memory Optimizer

La tâche planifiée `memory-optimizer-daily` (UUID: TUaSaGsi) peut être modifiée pour envoyer des rapports par email.

Exemple de prompt pour la tâche planifiée :

```
Utilise le skill himalaya pour envoyer un email avec le rapport d'optimisation des mémoires.

- Destinataire: ludo@ludoapex.fr
- Sujet: 📊 Rapport Memory Optimizer - [DATE]
- Contenu: Incluez le rapport d'analyse des mémoires
```

## Security Notes

- ⚠️ Le mot de passe est stocké en clair dans `/a0/usr/workdir/email_client.py`
- ⚠️ Pour une meilleure sécurité, utilisez un système de gestion des secrets
- ⚠️ Le fichier email_client.py ne doit pas être partagé publiquement

## Tips

1. **Utilisez le script Python** pour l'automatisation
2. **Sortie JSON** pour intégration facile
3. **Testez l'envoi** avec un email de test avant de l'utiliser en production
4. **Vérifiez les adresses email** avant d'envoyer
5. **Utilisez le format HTML** pour des rapports plus lisibles

---

**Version**: 1.1.0 (Script Python alternatif)  
**Last Updated**: 2026-02-12  
**Status**: Ready for use (email_client.py)  
**Email**: a0@ludoapex.fr (Agent Zero)
