#!/usr/bin/env python3
"""
Tag Generation Script for Obsidian Notes
Suggests relevant tags based on note content
"""

import re
import sys
from datetime import datetime

# Tag mapping patterns
TAG_PATTERNS = {
    # Type tags
    'project': [
        r'\bproject\b', r'\bg\u00e9rer\b', r'\bmanage\b', r'\bpipeline\b'
    ],
    'area': [
        r'\barea\b', r'\bresponsibility\b', r'\bongoing\b'
    ],
    'resource': [
        r'\bresource\b', r'\breference\b', r'\bguide\b', r'\bdoc\b'
    ],
    'archive': [
        r'\bcompleted\b', r'\bfinished\b', r'\bdone\b'
    ],
    # Subject tags
    'code': [
        r'\bpython\b', r'\bjavascript\b', r'\btypescript\b', r'\bgolang\b',
        r'\brust\b', r'\bsvelte\b', r'\breact\b', r'\bvue\b',
        r'\bapi\b', r'\bdatabase\b', r'\bfunction\b', r'\bclass\b',
        r'\bmodule\b', r'\bpackage\b', r'\bendpoint\b', r'\bserver\b'
    ],
    'python': [r'\bpython\b', r'\bpy\s*3\b', r'\bpip\b'],
    'javascript': [r'\bjavascript\b', r'\bjs\b', r'\bnode\.?js\b'],
    'typescript': [r'\btypescript\b', r'\bts\b', r'\bts\b'],
    'golang': [r'\bgolang\b', r'\bgo\s+lang\b'],
    'svelte': [r'\bsvelte\b', r'\b\.svelte\b'],
    'react': [r'\breact\b', r'\bjsx\b'],
    'vue': [r'\bvue\b', r'\bvue\.js\b'],
    # Nutrition & Food
    'nutrition': [
        r'\bnutrition\b', r'\bnutritionnel\b', r'\bdiet\b',
        r'\bcalories\b', r'\bprotein\b', r'\bcarbs\b'
    ],
    'recette': [
        r'\brecette\b', r'\brecipe\b', r'\bingredient\b',
        r'\bcuisine\b', r'\bcooking\b', r'\bmeal\b'
    ],
    'cuisine': [
        r'\bcuisine\b', r'\bcooking\b', r'\bcook\b'
    ],
    # Business & Finance
    'business': [
        r'\bbusiness\b', r'\bstartup\b', r'\benterprise\b',
        r'\bcompany\b', r'\bfirme\b'
    ],
    'marketing': [
        r'\bmarketing\b', r'\bpromotion\b', r'\badvertising\b',
        r'\bcampaign\b', r'\bseo\b'
    ],
    'finance': [
        r'\bfinance\b', r'\bfinancial\b', r'\bmoney\b',
        r'\binvest\b', r'\btrading\b', r'\bstock\b'
    ],
    # Health & Fitness
    'health': [
        r'\bhealth\b', r'\bsant\u00e9\b', r'\bmedical\b',
        r'\bdoctor\b', r'\bclinic\b', r'\bhospital\b'
    ],
    'fitness': [
        r'\bfitness\b', r'\bexercise\b', r'\bworkout\b',
        r'\bgym\b', r'\btraining\b'
    ],
    # Personal
    'family': [
        r'\bfamily\b', r'\bfamille\b', r'\bparent\b',
        r'\bchild\b', r'\brelative\b'
    ],
    'life': [
        r'\blife\b', r'\bvie\b', r'\bdaily\b', r'\broutine\b'
    ],
    # Technology
    'ai': [
        r'\bAI\b', r'\bartificial\s+intelligence\b', r'\bmachine\s+learning\b',
        r'\bml\b', r'\bdeep\s+learning\b', r'\bneural\b'
    ],
    'llm': [
        r'\bllm\b', r'\blanguage\s+model\b', r'\bgpt\b',
        r'\bclaude\b', r'\bchatgpt\b'
    ],
    # Gaming
    'gaming': [
        r'\bgaming\b', r'\bgamer\b', r'\bplay\b',
        r'\bgameplay\b', r'\bmultiplayer\b'
    ],
    # Self-hosting
    'selfhosting': [
        r'\bselfhosting\b', r'\bself.hosting\b', r'\bhosting\b',
        r'\bserver\b', r'\bvps\b', r'\bdeploy\b'
    ],
    'docker': [
        r'\bdocker\b', r'\bcontainer\b', r'\bimage\b'
    ],
    # Design
    'design': [
        r'\bdesign\b', r'\bui\b', r'\bux\b',
        r'\binterface\b', r'\blayout\b'
    ],
    'css': [r'\bcss\b', r'\bstyle\b', r'\bstylesheet\b'],
    # Media
    'video': [
        r'\bvideo\b', r'\byoutube\b', r'\brecording\b',
        r'\bstreaming\b', r'\bmedia\b'
    ],
    'book': [
        r'\bbook\b', r'\bauthor\b', r'\bchapter\b',
        r'\bpublisher\b', r'\breading\b', r'\blecture\b'
    ],
    # Task & Project Management
    'task': [
        r'\btask\b', r'\bto\s+do\b', r'\baction\b',
        r'\bchecklist\b', r'\bitem\b'
    ],
    'todo': [r'\bto\s+do\b', r'\btodo\b', r'\bpending\b'],
    'meeting': [
        r'\bmeeting\b', r'\bmeet\b', r'\bcall\b',
        r'\br\u00e9union\b', r'\bdiscussion\b'
    ],
    'idea': [
        r'\bidea\b', r'\bid\u00e9e\b', r'\bconcept\b',
        r'\bbrainstorm\b'
    ]
}

def generate_tags(content: str) -> list:
    """Generate relevant tags from note content."""
    content_lower = content.lower()
    tags = []
    
    for tag, patterns in TAG_PATTERNS.items():
        for pattern in patterns:
            if re.search(pattern, content_lower):
                tags.append(tag)
                break  # Only add each tag once
    
    return tags

def prioritize_tags(tags: list, max_tags: int = 10) -> list:
    """Prioritize tags based on importance and limit to max_tags."""
    # Priority order - type tags first, then specific subjects
    priority_order = [
        'project', 'area', 'resource', 'archive',
        'code', 'ai', 'business', 'health', 'family',
        'task', 'todo', 'meeting', 'idea',
        'python', 'javascript', 'typescript', 'svelte',
        'nutrition', 'recette', 'cuisine',
        'gaming', 'design', 'video', 'book'
    ]
    
    # Sort tags by priority
    prioritized = []
    for tag in priority_order:
        if tag in tags:
            prioritized.append(tag)
    
    # Add remaining tags not in priority list
    for tag in tags:
        if tag not in prioritized:
            prioritized.append(tag)
    
    return prioritized[:max_tags]

def suggest_tag_set(content: str, content_type: str = None) -> dict:
    """Suggest a comprehensive tag set for a note."""
    tags = generate_tags(content)
    prioritized = prioritize_tags(tags)
    
    result = {
        'suggested_tags': prioritized,
        'all_found_tags': tags,
        'tag_count': len(tags)
    }
    
    # Add type-specific suggestions
    if content_type:
        if content_type == 'recipe':
            result['suggested_tags'].extend(['nutrition', 'recette', 'cuisine'])
        elif content_type == 'code':
            if 'python' not in result['suggested_tags']:
                result['suggested_tags'].insert(0, 'code')
        elif content_type == 'task':
            if 'task' not in result['suggested_tags']:
                result['suggested_tags'].insert(0, 'task')
        elif content_type == 'meeting':
            if 'meeting' not in result['suggested_tags']:
                result['suggested_tags'].insert(0, 'meeting')
        elif content_type == 'idea':
            if 'idea' not in result['suggested_tags']:
                result['suggested_tags'].insert(0, 'idea')
    
    return result

if __name__ == '__main__':
    if len(sys.argv) > 1:
        # Read from file
        with open(sys.argv[1], 'r') as f:
            content = f.read()
        content_type = sys.argv[2] if len(sys.argv) > 2 else None
    else:
        # Read from stdin
        content = sys.stdin.read()
        content_type = None
    
    result = suggest_tag_set(content, content_type)
    
    print(f"=== Suggested Tags ({len(result['suggested_tags'])} tags) ===")
    print(", ".join(f"#{tag}" for tag in result['suggested_tags']))
    print(f"\n=== All Found Tags ({result['tag_count']}) ===")
    print(", ".join(f"#{tag}" for tag in result['all_found_tags']))
