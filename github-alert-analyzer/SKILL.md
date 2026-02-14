# GitHub Alert Analyzer - Skill Agent Zero

## Rôle
Analyser les alertes de sécurité GitHub reçues par email et générer des rapports d'action pour l'utilisateur.

## Sources d'Alertes
- GitGuardian (secrets exposés)
- GitHub Dependabot (vulnérabilités de dépendances)
- GitHub Code Scanning (failles de sécurité)
- Autres services CI/CD (failures de build)

## Workflow d'Analyse

### 1. Collecte
Interroger la boîte de réception pour identifier les emails pertinents.

**Mots-clés à rechercher** :
- GitGuardian
- Security
- Alert
- Vulnerability
- Secret

**Commande** :
```bash
python /a0/usr/workdir/email_client.py list --folder INBOX --limit 50
```

### 2. Lecture
Récupérer le contenu de l'alerte.

**Commande** :
```bash
python /a0/usr/workdir/email_client.py read <id_email>
```

### 3. Analyse et Actions
Selon le type d'alerte, déterminer les actions correctives :

#### Type A : Secret Exposé (GitGuardian)
- **Détails** : Fichier, Repository, Commit SHA.
- **Actions** :
  - Révoquer immédiatement le secret sur le service tiers (AWS, Stripe, etc.).
  - Remplacer le secret par une variable d'environnement.
  - Supprimer le commit de l'historique (si sensible) ou utiliser BFG.
  - Ignorer l'alerte dans GitGuardian une fois résolu.

#### Type B : Vulnérabilité de Dépendance (Dependabot)
- **Détails** : Package, Version actuelle, Version patch, Sévérité.
- **Actions** :
  - Mettre à jour le package vers la version sécurisée.
  - Vérifier les breaking changes.
  - Tester l'application.

#### Type C : Code Scanning Alert
- **Détails** : Emplacement, Règle SAST, Description.
- **Actions** :
  - Corriger le code source.
  - Ajouter des tests unitaires.

### 4. Rapport
Générer un rapport structuré envoyé à l'utilisateur.

**Destinataire** : `ludo@ludoapex.fr`

**Format du Rapport** :
```markdown
## Rapport d'Alerte Sécurité

### Type: [GitGuardian / Dependabot / Autre]

### Résumé
[Description courte du problème]

### Détails Techniques
- **Repository** : owner/repo
- **Fichier** : path/to/file (si applicable)

### Actions Recommandées
1. [Action 1 - Haute Priorité]
2. [Action 2]
3. [Action 3]

### Statut
[À faire / En cours / Résolu]
```

### 5. Notification
Utiliser la skill `himalaya` (email_client.py) pour envoyer le rapport.

## Exemple d'Exécution (Python)

```python
import subprocess
import json

# 1. Lister les emails
result = subprocess.run(
    ['python', '/a0/usr/workdir/email_client.py', 'list', '--folder', 'INBOX', '--limit', '20'],
    capture_output=True, text=True
)
emails = json.loads(result.stdout)['emails']

for email in emails:
    # 2. Filtrer les alertes GitGuardian
    if 'GitGuardian' in email['from']:
        # 3. Lire l'email
        read_result = subprocess.run(
            ['python', '/a0/usr/workdir/email_client.py', 'read', email['id']],
            capture_output=True, text=True
        )
        content = json.loads(read_result.stdout)
        
        # 4. Analyser (logique simplifiée)
        subject = content['subject']
        body = content['body']
        
        # ... Logique d'extraction d'information ...
        
        report = f"Alerte détectée : {subject}\n\nAction : Vérifier le fichier concerné."
        
        # 5. Envoyer le rapport
        subprocess.run([
            'python', '/a0/usr/workdir/email_client.py', 'send',
            '--to', 'ludo@ludoapex.fr',
            '--subject', f'Rapport Sécurité : {email['id']}',
            '--body', report
        ])
```

## Règles de Sécurité
- Ne **JAMAIS** inclure de secrets dans le rapport d'email.
- Ne pas répondre aux emails automatiques (noreply).
- Le rapport est destiné uniquement à `ludo@ludoapex.fr`.
