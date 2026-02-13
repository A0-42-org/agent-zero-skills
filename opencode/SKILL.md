---
name: "opencode"
description: "Open Code est l'agent de codage IA open source. Utilisez cette skill pour les tâches de codage complexes, le refactoring multi-fichiers, la planification d'architecture, ou lorsque vous avez besoin d'une analyse de code avancée avec support LSP. OpenCode fournit un environnement de codage spécialisé avec plusieurs agents (build, plan, general) et des modèles IA provider-agnostic."
version: "1.2.0"
author: "Agent Zero Team"
tags: ["codage", "agent", "ai-codage", "refactoring", "architecture", "lsp", "tui", "provider-agnostic"]
trigger_patterns:
  - "opencode"
  - "ai coding"
  - "refactoring code"
  - "analyse architecture"
  - "modifications multi-fichiers"
  - "analyse lsp"
  - "exploration code"
  - "complexité code"
---

# OpenCode - Agent de Codage IA

## Configuration Docker (Installation Réussie - 2026-02-12)

| Élément | Valeur |
|---------|--------|
| **Version** | v1.1.61 |
| **Installation** | npm install -g opencode-ai@latest |
| **Emplacement** | /usr/local/bin/opencode |
| **PATH** | Ajouté à ~/.bashrc et ~/.profile |
| **Authentification** | ✅ 1 credentials reconnus (Z.AI Coding Plan api) |

### Format auth.json Corrigé
```json
{
  "zai-coding-plan": {
    "type": "api",
    "key": "4030a74259ba4ae2af5b3318d61647b8.7ncYiOlF0LBMLjXP"
  }
}
```
**Emplacement** : `~/.local/share/opencode/auth.json`

### Note Importante sur Connectivité

Le domaine `api.zai.ai` **N'EXISTE PAS**.

Ce n'est PAS un problème de Docker - même sur le système hôte, `curl -I api.zai.ai` échoue avec "Could not resolve host".

L'authentification OpenCode est configurée correctement (1 credentials reconnus), mais OpenCode NE peut PAS utiliser l'API Zai car l'URL n'existe pas.

### Fichiers de Configuration
- `~/.local/share/opencode/auth.json` : Fichier d'authentification
- `~/.config/opencode/config.json` : Fichier de configuration provider
- `/a0/usr/workdir/opencode_wrapper.py` : Wrapper Python pour OpenCode
- `/a0/usr/workdir/OPencode_CLI_Documentation.md` : Documentation CLI OpenCode

---

## Quand Utiliser
Activez cette skill lorsque :
- Vous travaillez sur des **tâches de codage complexes** nécessitant une compréhension approfondie du code
- Vous effectuez un **refactoring multi-fichiers** ou des modifications à grande échelle
- Vous analysez **l'architecture du codebase** ou des projets inconnus
- Vous avez besoin d'une **analyse de code avancée** avec support LSP
- Vous planifiez des **changements complexes** avant l'implémentation
- Vous explorez de **grandes bases de code** avec une navigation intelligente
- Les tâches bénéficient d'une **assistance d'agent IA** avec des rôles spécialisés
- **Review de code** ou scénarios d'audit de sécurité
- **Optimisation de performance** nécessitant une analyse du codebase entier


## Quand NE PAS Utiliser
- Exécution de scripts simples ou modifications d'une ligne (utilisez `code_execution_tool`)
- Éditions rapides de fichiers ou petites modifications
- Commandes terminal sans analyse de code
- Appels API directs ou requêtes réseau
- Installation de paquets (utilisez le terminal)

## Architecture OpenCode

### CLI vs Outil d'exécution de code

| Approche | Idéal Pour | Vitesse | Complexité |
|-----------|-------------|----------|------------|
| **OpenCode** | Codage complexe, modifications multi-fichiers, architecture | Moyenne | Élevée |
| **code_execution_tool** | Scripts simples, modifications rapides, terminal | Rapide | Faible |

### Matrice de Décision

**Utilisez OpenCode quand :**
- La tâche implique **3+ fichiers**
- Nécessite de **comprendre les relations entre les fichiers**
- Besoin de **planifier avant d'implémenter**
- Travail avec un **codebase inconnu**
- **Grand refactoring** nécessaire

**Utilisez code_execution_tool quand :**
- Exécution de script simple
- Modifications de fichiers uniques
- Corrections rapides ou petits changements
- Installation de paquets
- Commandes terminal directes

## Intégration OpenCode

### Vérification d'Installation
Vérifiez que le CLI OpenCode est installé :
```bash
opencode --version
```

### Vérification d'Authentification
Vérifiez que les credentials sont configurés :
```bash
opencode auth list
```
Devrait afficher :
```
┌  Credentials ~/.local/share/opencode/auth.json
│
●  Z.AI Coding Plan api
│
└  1 credentials
```

### Utilisation Directe
```bash
# Exécuter une tâche de codage
opencode run "Implémentez l'authentification utilisateur avec des jetons JWT"

# Lancer l'interface TUI interactive
opencode
```

## Agents OpenCode

### 1. **build** Agent (Par défaut)
**Objectif :** Agent d'accès complet pour le développement

**Idéal pour :**
- Implémentation de fonctionnalités
- Correction de bugs
- Écriture de nouveau code
- Exécution de tests
- Déploiement de changements

**Accès :**
- Lecture de fichiers
- Modification de fichiers
- Exécution de commandes bash
- Exécution de tests

### 2. **plan** Agent (Read-Only)
**Objectif :** Agent d'analyse et d'exploration de code

**Caractéristiques :**
- ✅ Refuse les modifications de fichiers par défaut
- ✅ Demande la permission avant les commandes bash
- ✅ Idéal pour explorer des bases de code inconnues
- ✅ Parfait pour planifier des refactors

**Idéal pour :**
- Analyse de code existant
- Exploration d'architecture
- Planification de refactors
- Audit de sécurité
- Compréhension des dépendances

**Basculer vers plan :** Appuyez sur `Tab` dans l'interface TUI OpenCode

### 3. **general** Agent
**Objectif :** Agent pour les recherches complexes et tâches multi-étapes
**Idéal pour :**
- Recherches de codebase complexes
- Refactoring multi-étapes
- Analyse multi-fichiers
- Enquêtes complexes

**Invoquer :** Utilisez `@general` dans les messages

### Guide de Sélection d'Agent

| Type de Tâche | Agent Recommandé |
|---------------|-------------------|
| **Nouvelle fonctionnalité** | build |
| **Correction de bug** | build |
| **Analyse de codebase** | plan |
| **Audit de sécurité** | plan |
| **Planification refactoring** | plan |
| **Recherche complexe** | general |
| **Enquête multi-étapes** | general |

## Modèles d'Utilisation
### Modèle 1: Exploration avec l'agent plan

Lorsque vous travaillez avec un code inconnu :

1. **Basculez vers l'agent plan** (touche Tab)
2. **Demandez une analyse :**
   ```
   Explorez ce codebase et expliquez l'architecture
   ```
3. **Passez en revue les résultats** avant d'implémenter
4. **Basculez vers l'agent build** pour l'implémentation

### Modèle 2: Implémentation avec l'agent build

Pour les tâches de codage :

1. **Utilisez l'agent build** (par défaut)
2. **Décrivez la tâche clairement :**
   ```
   Implémentez l'authentification utilisateur avec des jetons JWT
   ```
3. **Passez en revue les changements** au fur et à mesure qu'OpenCode les fait
4. **Testez** l'implémentation

### Modèle 3: Recherche Complexe avec l'agent general

Pour les enquêtes :

1. **Invoquez l'agent general :**
   ```
   @general Trouvez tous les fichiers qui utilisent des connexions base de données
   ```
2. **Passez en revue les résultats**
3. **Utilisez les résultats** pour votre tâche

## Intégration avec Agent Zero

### Intégration Subagent

Lors de la délégation au subagent développeur ou svelte :

1. **Charger la skill opencode** (automatique)
2. **Utiliser OpenCode** pour les tâches complexes
3. **Retomber sur code_execution_tool** pour les tâches simples
4. **Combiner les deux** pour un workflow optimal

### Exemple de Workflow

**Tâche :** Ajouter l'authentification à l'API

1. **Utiliser l'agent plan** via OpenCode pour analyser le code actuel
2. **Passez en revue l'architecture** et les dépendances
3. **Basculez vers l'agent build** pour l'implémentation
4. **Testez** en utilisant code_execution_tool
5. **Itérez** avec les deux outils

## Bonnes Pratiques

### 1. Utilisez l'agent plan pour l'Exploration
Explorez toujours les codebases inconnus avec l'agent plan avant de faire des changements.

### 2. Exploitez le Support LSP
Le support LSP d'OpenCode fournit :
- Navigation intelligente dans le code
- Détection d'erreurs en temps réel
- Autocomplétion intelligente
- Analyse multi-références

### 3. Combinez avec l'Outil d'Exécution de Code
- Utilisez OpenCode pour le codage complexe et l'analyse
- Utilisez code_execution_tool pour les scripts rapides et les commandes terminal
- Optimisez le workflow en choisissant le bon outil

### 4. Avantage Provider-Agnostic
OpenCode fonctionne avec plusieurs providers :
- Choisissez le meilleur modèle pour votre tâche
- Changez de provider en fonction des performances
- Utilisez des modèles locaux pour la confidentialité

### 5. Itérez et Affinez
- Commencez avec l'agent plan pour la compréhension
- Basculez vers build pour l'implémentation
- Testez avec code_execution_tool
- Affinez en fonction des résultats

## Workflows Courants

### Workflow 1: Développement de Nouvelle Fonctionnalité

1. **Agent plan :** Analysez l'architecture du codebase
2. **Passez en revue les dépendances** et les modèles existants
3. **Agent build :** Implémentez la fonctionnalité
4. **Testez :** Exécutez les tests via code_execution_tool
5. **Itérez :** Affinez en fonction des résultats

### Workflow 2: Correction de Bug

1. **Agent plan :** Analysez l'emplacement du bug
2. **Comprenez le contexte** et les dépendances
3. **Agent build :** Corrigez le bug
4. **Testez :** Vérifiez que la correction fonctionne
5. **Passez en revue :** Vérifiez les effets secondaires

### Workflow 3: Grand Refactoring

1. **Agent plan :** Analysez la structure actuelle
2. **Identifiez les changements** nécessaires
3. **Agent build :** Implémentez le refactoring
4. **Testez :** Toutes les fonctionnalités fonctionnent toujours
5. **Optimisez :** Améliorations de performance

### Workflow 4: Review de Code

1. **Agent plan :** Analysez les changements
2. **Passez en revue pour :**
   - Problèmes de sécurité
   - Problèmes de performance
   - Qualité du code
   - Bonnes pratiques
3. **Agent build :** Implémentez les corrections
4. **Testez :** Vérifiez les améliorations

## Dépannage

### OpenCode Non Trouvé
```bash
# Vérifiez l'installation
which opencode
opencode --version
```

### Problèmes de Credentials
```bash
# Vérifiez la configuration
opencode auth list
```
Devrait afficher `1 credentials` avec `Z.AI Coding Plan api`

### Problème de Connexion API Zai
Le domaine `api.zai.ai` **N'EXISTE PAS**.

Ce n'est PAS un problème de Docker - même sur le système hôte, ce domaine n'est pas résolvable.

L'authentification est correcte, mais OpenCode NE peut PAS utiliser l'API Zai car l'URL n'existe pas.

## Comparaison: OpenCode vs code_execution_tool

| Fonctionnalité | OpenCode | code_execution_tool |
|---------------|-----------|------------------|
| **Cas d'usage** | Codage complexe, architecture | Scripts simples, terminal |
| **Compréhension du code** | Approfondie (LSP, analyse IA) | Basique (exécution directe) |
| **Multi-fichiers** | Excellent | Limité |
| **Refactoring** | Excellent | Manuel |
| **Vitesse** | Moyenne | Rapide |
| **Dépendances** | CLI OpenCode | Aucune |
| **Support LSP** | Oui | Non |
| **Agents IA** | 3 agents spécialisés | Aucun |
| **Choix de provider** | Agnostic | LLM d'Agent Zero |

## Conclusion

OpenCode est **idéal pour les tâches de codage complexes** nécessitant une compréhension approfondie du code, des modifications multi-fichiers ou une planification d'architecture.

code_execution_tool est **idéal pour les tâches simples** comme exécuter des scripts, faire des éditions rapides ou exécuter des commandes terminal.

**Bonne pratique :** Utilisez les deux outils de manière stratégique en fonction de la complexité de la tâche.

---

**Skill créée et mise à jour par Agent Zero pour l'intégration OpenCode (2026-02-12)**
Version: 1.2.0 (Configuration Docker réussie, correction sur api.zai.ai)
Référence documentation: /a0/usr/workdir/OPencode_CLI_Documentation.md
Intégration MCP: https://gitmcp.io/anomalyco/opencode
