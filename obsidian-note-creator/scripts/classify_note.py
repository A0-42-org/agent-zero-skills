#!/usr/bin/env python3
"""
Note Classification Script for Obsidian PARA Method
Analyzes note content and suggests optimal PARA location
"""

import re
import sys
from datetime import datetime

# Classification patterns
PATTERNS = {
    'project': [
        r'\bdeadline\b', r'\bdue\s+date\b', r'\bto\s+do\b', r'\btask\b',
        r'\bmilestone\b', r'\bgoal\b', r'\bfinish\b', r'\bcomplete\b',
        r'\bpending\b', r'\bin\s+progress\b', r'\burgent\b'
    ],
    'area': [
        r'\bongoing\b', r'\brecurring\b', r'\bresponsibility\b',
        r'\bhealth\b', r'\bfitness\b', r'\bnutrition\b', r'\bfamily\b',
        r'\bfinance\b', r'\bgaming\b', r'\bgeek\b', r'\blife\b',
        r'\bnature\b', r'\bcode\b.*\blearning\b'
    ],
    'resource': [
        r'\breference\b', r'\bdocumentation\b', r'\btutorial\b',
        r'\bguide\b', r'\bmanual\b', r'\bexample\b', r'\btemplate\b',
        r'\bsnippet\b', r'\bbook\b', r'\barticle\b', r'\breading\b'
    ],
    'archive': [
        r'\bcompleted\b', r'\bfinished\b', r'\barchived\b',
        r'\bold\b', r'\bpast\b', r'\bhistory\b', r'\breviewed\b'
    ]
}

# Subject categories
SUBJECT_PATTERNS = {
    'code': [
        r'\bpython\b', r'\bjavascript\b', r'\btypescript\b', r'\bgolang\b',
        r'\brust\b', r'\bsvelte\b', r'\breact\b', r'\bvue\b',
        r'\bapi\b', r'\bdatabase\b', r'\bfunction\b', r'\bclass\b',
        r'\bmodule\b', r'\bpackage\b'
    ],
    'nutrition': [
        r'\brecette\b', r'\brecipe\b', r'\bingredient\b', r'\bcuisine\b',
        r'\bcooking\b', r'\bfood\b', r'\bmeal\b', r'\bdish\b'
    ],
    'business': [
        r'\bbusiness\b', r'\bstartup\b', r'\bmarketing\b', r'\bsales\b',
        r'\bfinance\b', r'\binvest\b', r'\brevenue\b', r'\bcustomer\b'
    ],
    'ai': [
        r'\bAI\b', r'\bartificial\s+intelligence\b', r'\bmachine\s+learning\b',
        r'\bllm\b', r'\bgpt\b', r'\bclaude\b', r'\bmodel\b'
    ],
    'gaming': [
        r'\bgames?\b', r'\bgaming\b', r'\bplay\b', r'\bgameplay\b',
        r'\bsteam\b', r'\bnintendo\b', r'\bplaystation\b'
    ],
    'selfhosting': [
        r'\bserver\b', r'\bhosting\b', r'\bdeploy\b', r'\bdocker\b',
        r'\bcontainer\b', r'\bcloud\b', r'\bvps\b'
    ],
    'design': [
        r'\bdesign\b', r'\bui\b', r'\bux\b', r'\blayout\b',
        r'\bcss\b', r'\bcolor\b', r'\bfont\b'
    ],
    'video': [
        r'\bvideo\b', r'\byoutube\b', r'\brecording\b',
        r'\bstreaming\b', r'\bmedia\b'
    ],
    'book': [
        r'\bbook\b', r'\bauthor\b', r'\bchapter\b', r'\bpublisher\b',
        r'\breading\b', r'\b\u00e9crit\b', r'\broman\b'
    ]
}

def classify_content(content: str) -> dict:
    """Analyze content and classify it according to PARA method."""
    content_lower = content.lower()
    
    scores = {
        'project': 0,
        'area': 0,
        'resource': 0,
        'archive': 0
    }
    
    # Count pattern matches
    for category, patterns in PATTERNS.items():
        for pattern in patterns:
            matches = len(re.findall(pattern, content_lower))
            scores[category] += matches
    
    # Determine primary category
    max_score = max(scores.values())
    if max_score == 0:
        primary = 'inbox'
    else:
        primary = max(scores, key=scores.get)
    
    # Identify subject tags
    subject_tags = []
    for subject, patterns in SUBJECT_PATTERNS.items():
        for pattern in patterns:
            if re.search(pattern, content_lower):
                subject_tags.append(subject)
                break
    
    return {
        'primary_location': primary,
        'subject_tags': subject_tags,
        'scores': scores
    }

def suggest_location(classification: dict) -> dict:
    """Suggest specific file path based on classification."""
    primary = classification['primary_location']
    subjects = classification['subject_tags']
    
    if primary == 'inbox':
        return {
            'path': '0. 📬 Inbox/',
            'reason': 'Unclear classification or new content'
        }
    
    path_map = {
        'project': '1. ⚙ Project/',
        'area': '2. 🛸 Area/',
        'resource': '3. 💭 Resource/',
        'archive': '4. 📦 Archive/'
    }
    
    base_path = path_map.get(primary, '0. 📬 Inbox/')
    
    # Add subject subfolder if available
    if subjects:
        subject = subjects[0]  # Use first subject
        if primary == 'area':
            subfolder = subject.capitalize()
        elif primary == 'resource':
            subfolder = subject.capitalize()
        else:
            subfolder = ''
        
        if subfolder:
            full_path = f"{base_path}{subfolder}/"
        else:
            full_path = base_path
    else:
        full_path = base_path
    
    return {
        'path': full_path,
        'reason': f"Based on {primary} classification" + (f" with {subjects[0]} focus" if subjects else "")
    }

def suggest_template(content: str, classification: dict) -> str:
    """Suggest appropriate template based on content and classification."""
    content_lower = content.lower()
    
    # Check for specific content types
    if re.search(r'\brecette\b|\brecipe\b|\bingredient\b', content_lower):
        return 'recipe'
    if re.search(r'\bdef\s+\w+|\bfunction\b|\bclass\s+\w+|\bimport\s+', content_lower):
        return 'code-snippet'
    if re.search(r'\bto\s+do\b|\btask\b|\bchecklist\b|\bdeadline\b', content_lower):
        return 'task-quick'
    if re.search(r'\bidea\b|\bide\u00e9e\b|\bmaybe\b|\bbrainstorm\b', content_lower):
        return 'idea-quick'
    if re.search(r'\bmeeting\b|\bmeet\b|\br\u00e9union\b|\bcall\b', content_lower):
        return 'meeting'
    if re.search(r'\bbook\b|\bchapter\b|\bauthor\b|\breading\b', content_lower):
        return 'book'
    
    # Default based on PARA classification
    if classification['primary_location'] == 'resource':
        return 'reference-quick'
    
    return 'quick-note'

if __name__ == '__main__':
    if len(sys.argv) > 1:
        # Read from file
        with open(sys.argv[1], 'r') as f:
            content = f.read()
    else:
        # Read from stdin
        content = sys.stdin.read()
    
    classification = classify_content(content)
    location = suggest_location(classification)
    template = suggest_template(content, classification)
    
    print(f"=== Classification Results ===")
    print(f"Primary Location: {classification['primary_location']}")
    print(f"Subject Tags: {', '.join(classification['subject_tags'])}")
    print(f"\n=== Suggested Location ===")
    print(f"Path: {location['path']}")
    print(f"Reason: {location['reason']}")
    print(f"\n=== Suggested Template ===")
    print(f"Template: {template}.md")
