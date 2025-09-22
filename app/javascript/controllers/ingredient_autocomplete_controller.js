import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["search", "dropdown", "quickAddForm", "detailsForm",
        "selectedId", "newName", "newCategory", "quantity", "unit", "notes"]

    static values = {recipeId: String}

    connect() {
        this.searchTimeout = null
        this.selectedIngredient = null
    }

    search() {
        const query = this.searchTarget.value.trim()

        // Clear previous timeout
        clearTimeout(this.searchTimeout)

        if (query.length < 2) {
            this.hideDropdown()
            return
        }

        // Debounce search requests
        this.searchTimeout = setTimeout(() => {
            this.performSearch(query)
        }, 300)
    }

    async performSearch(query) {
        try {
            const response = await fetch(`/ingredients/search?q=${encodeURIComponent(query)}`, {
                headers: {
                    "Accept": "application/json"
                }
            })

            const ingredients = await response.json()
            this.showDropdown(ingredients, query)
        } catch (error) {
            console.error("Search failed:", error)
        }
    }

    showDropdown(ingredients, query) {
        this.dropdownTarget.innerHTML = ""

        // Show existing ingredients
        ingredients.forEach(ingredient => {
            const item = this.createDropdownItem(ingredient)
            this.dropdownTarget.appendChild(item)
        })

        // Add "create new" option
        const addNewItem = document.createElement("div")
        addNewItem.className = "dropdown-item border-top"
        addNewItem.innerHTML = `
      <div class="d-flex align-items-center text-success">
        <i class="bi bi-plus-circle me-2"></i>
        <strong>Add "${query}" as new ingredient</strong>
      </div>
    `
        addNewItem.addEventListener("click", () => this.showQuickAdd(query))
        this.dropdownTarget.appendChild(addNewItem)

        this.dropdownTarget.style.display = "block"
    }

    createDropdownItem(ingredient) {
        const item = document.createElement("div")
        item.className = "dropdown-item"
        item.style.cursor = "pointer"
        item.innerHTML = `
      <div>
        <strong>${ingredient.name}</strong>
        <small class="text-muted ms-2">${ingredient.category}</small>
      </div>
    `

        item.addEventListener("click", () => this.selectIngredient(ingredient))
        return item
    }

    selectIngredient(ingredient) {
        this.selectedIngredient = ingredient
        this.searchTarget.value = ingredient.name
        this.selectedIdTarget.value = ingredient.id
        this.hideDropdown()
        this.showDetails()
    }

    showQuickAdd(suggestedName = "") {
        this.newNameTarget.value = suggestedName
        this.hideDropdown()
        this.quickAddFormTarget.style.display = "block"
        this.detailsFormTarget.style.display = "none"
    }

    showDetails() {
        this.quickAddFormTarget.style.display = "none"
        this.detailsFormTarget.style.display = "block"
    }

    hideDropdown() {
        this.dropdownTarget.style.display = "none"
    }

    clearForms() {
        this.searchTarget.value = ""
        this.selectedIngredient = null
        this.selectedIdTarget.value = ""
        this.quickAddFormTarget.style.display = "none"
        this.detailsFormTarget.style.display = "none"
        this.hideDropdown()

        // Clear detail form
        this.quantityTarget.value = ""
        this.notesTarget.value = ""
    }

    async saveNewIngredient() {
        const name = this.newNameTarget.value.trim()
        const category = this.newCategoryTarget.value

        if (!name || !category) {
            alert("Please fill in ingredient name and category")
            return
        }

        try {
            const response = await fetch("/ingredients", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    ingredient: {
                        name: name,
                        category: category,
                        calories_per_100g: 0
                    }
                })
            })

            const data = await response.json()

            if (data.success) {
                this.selectIngredient({
                    id: data.id,
                    name: data.name,
                    category: data.category
                })

                // Clear form
                this.newNameTarget.value = ""
                this.newCategoryTarget.value = ""
            } else {
                alert("Error: " + data.errors.join(", "))
            }
        } catch (error) {
            console.error("Failed to create ingredient:", error)
            alert("Error creating ingredient")
        }
    }

    async addToRecipe() {
        if (!this.selectedIngredient) {
            alert("Please select an ingredient first")
            return
        }

        const quantity = this.quantityTarget.value
        const unit = this.unitTarget.value
        const notes = this.notesTarget.value

        if (!quantity || !unit) {
            alert("Please fill in quantity and unit")
            return
        }

        const formData = new FormData()
        formData.append("recipe_ingredient[ingredient_id]", this.selectedIngredient.id)
        formData.append("recipe_ingredient[quantity]", quantity)
        formData.append("recipe_ingredient[unit]", unit)
        formData.append("recipe_ingredient[notes]", notes)

        try {
            const response = await fetch(`/recipes/${this.recipeIdValue}/recipe_ingredients`, {
                method: "POST",
                headers: {
                    "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
                },
                body: formData
            })

            if (response.ok) {
                // Use Turbo to refresh just the ingredients section
                window.location.reload()
            } else {
                alert("Error adding ingredient to recipe")
            }
        } catch (error) {
            console.error("Failed to add ingredient:", error)
            alert("Error adding ingredient")
        }
    }

    // Handle clicking outside to close dropdown
    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.hideDropdown()
        }
    }
}