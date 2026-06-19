#!/bin/bash
echo "=== Configuration du nouveau dépôt distant ==="
git remote add mgdigi https://github.com/mgdigi/terangaSkillsMobile.git 2>/dev/null || git remote set-url mgdigi https://github.com/mgdigi/terangaSkillsMobile.git

echo ""
echo "=== Création de la nouvelle branche ==="
read -p "Entrez le nom de la nouvelle branche (ex: correction-mode-sombre) : " branch_name

if [ -z "$branch_name" ]; then
  echo "Erreur : Le nom de la branche ne peut pas être vide."
  exit 1
fi

git checkout -b "$branch_name"

echo ""
echo "=== Envoi du code sur la branche '$branch_name' de mgdigi ==="
git push mgdigi "$branch_name"

echo ""
echo "Terminé !"
read -p "Appuyez sur Entrée pour quitter..."
