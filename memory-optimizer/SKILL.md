---
name: "memory-optimizer"
description: "Analyse, nettoie et optimise les mémoires Agent Zero. Identifie les duplications, obsolètes, méta-informations et propose des consolidations. Utilise régulièrement pour maintenir une base de mémoires propre et efficace."
version: "1.0.0"
author: "Agent Zero Team"
tags: ["memory", "optimization", "cleanup", "maintenance", "meta"]
trigger_patterns:
  - "analyser mémoires"
  - "nettoyer mémoires"
  - "optimiser mémoire"
  - "memory cleanup"
  - "memory analysis"
  - "duplicate memories"
---

# Memory Optimizer

## When to Use
Activez ce skill quand :
- L'utilisateur demande d'analyser ou optimiser les mémoires
- Des duplications sont suspectées dans la base de mémoires
- Des fichiers référencés dans les mémoires n'existent plus
- Une maintenance régulière est souhaitée (recommandé : mensuel)

## The Process

### Step 1: Load All Memories
```python
# Load all memories without filter
memory_load(query="", threshold=0, limit=1000)
```

### Step 2: Identify Categories
Analysez les mémoires pour identifier :

#### 2.1 Mémoires Obsolètes (fichiers supprimés)
Vérifiez si les fichiers référencés existent encore :
```bash
ls -la /a0/usr/workdir/
```
Critères de suppression :
- Fichiers ACP obsolètes : `acp_opencode.py`, `acp_opencode_v2.py`, `GUIDE_ACP_AGENT_ZERO.md`, `integration_opencode.py`
- Scripts obsolètes : `fix_rate_limits.py`
- Fichiers de test temporaires

#### 2.2 Mémoires en Double
Identifiez les mémoires avec contenu similaire :
- Comparez le contenu textuel
- Cherchez des IDs avec `_consolidation_similarity: 0.9+`
- Identifiez la mémoire la plus complète comme "cible"

Types courants de duplications :
- Profil utilisateur (name: John Doe vs Ludo)
- OpenCode config (multiple versions)
- Maxun information
- GitMCP workflow
- Permissions d'installation

#### 2.3 Méta-Informations
Mémoires qui décrivent des actions déjà effectuées :
- "Cleaning completed at..."
- "Memory saved with id..."
- "Confirmation of..."

Ces mémoires ne sont plus nécessaires après l'action.

#### 2.4 Documentation Agent Zero (Optionnel)
Mémoires volumineuses marquées `knowledge_source: True` :
- `github_readme.md`
- `installation.md`
- Autres fichiers de documentation Agent Zero

Critère de suppression :
- Accessibles via GitMCP : https://gitmcp.io/agent0ai/agent-zero
- MCP permanent configuré dans `/a0/usr/settings.json`

Alternative : Conserver si l'accès hors-ligne est important.

### Step 3: Select Memories to Keep
Identifiez les mémoires "autorité" pour chaque catégorie :
- Plus complète et à jour
- Information correcte (ex: nom d'utilisateur correct)
- Timestamp récent

### Step 4: Delete Obsolete/Duplicate Memories
```python
memory_delete(ids="id1,id2,id3,...")
```

### Step 5: Consolidation (Optionnel)
Pour les mémoires à consolider :
1. Charger la mémoire cible
2. Fusionner avec les mémoires sources
3. Créer une nouvelle mémoire consolidée
4. Supprimer les mémoires sources

### Step 6: Generate Report
Fournissez un rapport détaillé :
- Total mémoires analysées
- Mémoires supprimées (avec IDs)
- Mémoires conservées
- Réduction obtenue (%)
- Recommandations futures

## Optimization Checklist
- [ ] Charger toutes les mémoires
- [ ] Identifier les mémoires obsolètes (fichiers supprimés)
- [ ] Identifier les mémoires en double
- [ ] Identifier les méta-informations
- [ ] Vérifier si documentation Agent Zero est accessible via GitMCP
- [ ] Sélectionner les mémoires "autorité"
- [ ] Supprimer les mémoires obsolètes/dupliquées
- [ ] Consolider si nécessaire
- [ ] Générer un rapport complet

## Common Issues

### Issue: Incorrect User Information
**Symptôme**: Mémoire contient "John Doe" alors que l'utilisateur est "Ludo"
**Solution**: Supprimer toutes les mémoires avec info incorrecte, conserver celle avec info correcte.

### Issue: Multiple OpenCode Versions
**Symptôme**: Plusieurs mémoires OpenCode avec des versions différentes
**Solution**: Conserver la plus récente et complète (ex: v1.2.0), supprimer les anciennes.

### Issue: Files Referenced Don't Exist
**Symptôme**: Mémoire mentionne `/a0/usr/workdir/fix_rate_limits.py` mais le fichier n'existe pas
**Solution**: Supprimer la mémoire obsolète.

### Issue: Duplicate GitMCP Documentation
**Symptôme**: Mémoires GitHub install.md existent mais GitMCP MCP permanent est configuré
**Solution**: Supprimer les mémoires de documentation si GitMCP permanent fonctionne.

## Example Usage

### Full Analysis
```python
# User: "Analyse mes mémoires et optimise-les"

# Step 1: Load all memories
memories = memory_load(query="", threshold=0, limit=1000)

# Step 2: Analyze and categorize
# (Analysis as per process above)

# Step 3: Delete
memory_delete(ids="aaLXUVsfZn,xlwpcXRKcZ,Rn7YZRCFNP,...")

# Step 4: Report
print(f"Deleted: 28 memories")
print(f"Kept: 8 authority memories")
print(f"Reduction: 36%")
```

### Quick Cleanup
```python
# User: "Nettoie les mémoires obsolètes"

# Focus only on obsolete memories (files deleted)
memory_delete(ids="6fFqNInLju,giDISdwGbm")
```

## Tips

1. **Always check file existence** before deciding to keep memory
2. **Keep the most recent and complete** memory for each category
3. **Verify GitMCP connectivity** before deleting Agent Zero documentation
4. **Double-check user information** for correctness
5. **Use researcher subordinate** for large-scale analysis (100+ memories)
6. **Generate detailed report** for transparency

## Files Referenced
- `/a0/usr/settings.json` - MCP permanent configuration
- `/a0/usr/workdir/` - Working directory files
- GitMCP: https://gitmcp.io/agent0ai/agent-zero

## Memory Types to Keep as Authority

### User Profile
- Correct user name (Ludo, not John Doe)
- Skills stack (SvelteKit, full-stack dev)
- Preferred models (Zai GLM-4.7)

### OpenCode
- Most recent version (v1.2.0+)
- Docker installation details
- Integration workflow with Agent Zero
- Agent profiles (developer, svelte)

### Maxun
- Complete ecosystem description
- GitMCP integration
- Docker self-hosting info
- 4 robot types

### GitMCP Workflow
- Script Python for temporary connections
- Permanent vs temporary workflow
- MCP server configuration

### Policies
- Installation permissions
- Security (no API keys in plain text)
- File cleanup procedures

---

**Version**: 1.0.0  
**Last Updated**: 2026-02-12
**Status**: Ready for use
