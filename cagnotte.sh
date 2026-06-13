#!/bin/bash

echo "--- AJOUT D'UN NOUVEAU DON ---"

# 1. Demander les informations
read -p "Nom du donateur : " nom
if [ -z "$nom" ]; then
    echo "❌ Erreur : Le nom ne peut pas être vide."
    exit 1
fi

read -p "Montant du don (FCFA) : " montant
# Vérifier si le montant est bien un nombre
if ! [[ "$montant" =~ ^[0-9]+$ ]]; then
    echo "❌ Erreur : Le montant doit être un nombre entier."
    exit 1
fi

fichier="index.html"

# 2. Vérifier si le fichier existe
if [ ! -f "$fichier" ]; then
    echo "❌ Erreur : Le fichier $fichier est introuvable."
    exit 1
fi

# 3. Préparer la ligne à insérer
nouvelle_ligne="    { name: \"$nom\", amount: $montant },"

# Insérer la ligne juste après 'const list = ['
# On utilise 'sed' pour modifier le fichier directement
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Syntaxe spéciale pour macOS
    sed -i "" "/const list = \[/a\\
$nouvelle_ligne" "$fichier"
else
    # Syntaxe standard pour Linux / Git Bash Windows
    sed -i "/const list = \[/a $nouvelle_ligne" "$fichier"
fi

echo "✅ $nom ($montant F) ajouté avec succès dans index.html !"

# 4. Automatisation des commandes Git
echo ""
echo "🚀 Envoi des modifications sur GitHub..."

git add .
git commit -m "Ajout du don de $nom ($montant F)"
git push origin main

echo ""
echo "🎉 Tout est en ligne ! Render va mettre à jour ton site d'ici une minute."
