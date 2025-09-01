# RSpec: Request Specs: Testing Rails Controllers and APIs

In this lesson, you'll learn how to write RSpec request specs to test your Rails controllers and APIs. We'll cover what request specs are, why they're important, and how to use them to test GET, POST, PATCH, and DELETE requests. We'll also show you how to check responses, status codes, and JSON bodies. If you know Ruby and Rails but are new to automated testing, this is your guide to end-to-end request testing!

---

## What Are Request Specs?

Request specs are high-level tests that exercise your app like a real user or client would—by making HTTP requests to your Rails app. They:

- Test the full stack (routing, controllers, models, views, etc.)
- Are perfect for testing APIs and controller endpoints
- Help ensure your app responds correctly to real-world requests

---

## Setting Up Request Specs

By default, Rails puts request specs in `/spec/requests/`.

```ruby
# /spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users API", type: :request do
  # ...examples go here...
end
```

---

## Example: Testing a GET Request

Suppose you have a `ScientistsController` with an index action:

```ruby
# /app/controllers/scientists_controller.rb
class ScientistsController < ApplicationController
  def index
    @scientists = Scientist.all
    render json: @scientists
  end
end
```

Here's how you might test it:

```ruby
# /spec/requests/scientists_spec.rb
require 'rails_helper'

RSpec.describe "Scientists API", type: :request do
  describe "GET /scientists" do
    it "returns a list of scientists" do
      Scientist.create!(name: "Ada Lovelace", field: "Mathematics")
      Scientist.create!(name: "Marie Curie", field: "Physics")
      get "/scientists"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end
end
```

---

## Example: Testing a POST Request

Suppose you have a create action:

```ruby
# /app/controllers/scientists_controller.rb
class ScientistsController < ApplicationController
  def create
    scientist = Scientist.create(scientist_params)
    if scientist.persisted?
      render json: scientist, status: :created
    else
      render json: scientist.errors, status: :unprocessable_entity
    end
  end

  private
  def scientist_params
    params.require(:scientist).permit(:name, :field)
  end
end
```

Test the POST:

```ruby
# /spec/requests/scientists_spec.rb
it "creates a scientist" do
  post "/scientists", params: { scientist: { name: "Rosalind Franklin", field: "Chemistry" } }
  expect(response).to have_http_status(:created)
  expect(JSON.parse(response.body)["name"]).to eq("Rosalind Franklin")
end
```

---

## Example: Testing a PATCH Request

Suppose you have an update action:

```ruby
# /app/controllers/scientists_controller.rb
class ScientistsController < ApplicationController
  def update
    scientist = Scientist.find(params[:id])
    if scientist.update(scientist_params)
      render json: scientist
    else
      render json: scientist.errors, status: :unprocessable_entity
    end
  end
end
```

Test the PATCH:

```ruby
# /spec/requests/scientists_spec.rb
let!(:scientist) { Scientist.create!(name: "Ada Lovelace", field: "Mathematics") }

it "updates a scientist" do
  patch "/scientists/#{scientist.id}", params: { scientist: { field: "Computer Science" } }
  expect(response).to have_http_status(:ok)
  expect(JSON.parse(response.body)["field"]).to eq("Computer Science")
end
```

---

## Example: Testing a DELETE Request

```ruby
# /spec/requests/scientists_spec.rb
let!(:scientist) { Scientist.create!(name: "Marie Curie", field: "Physics") }

it "deletes a scientist" do
  expect {
    delete "/scientists/#{scientist.id}"
  }.to change { Scientist.count }.by(-1)
  expect(response).to have_http_status(:no_content).or have_http_status(:success)

  # Why two possible status codes?
  # Depending on your Rails version and controller implementation, a successful DELETE may return either:
  # - `204 No Content` (preferred for APIs, means the resource was deleted and there’s no response body)
  # - `200 OK` (older Rails defaults, or if you render something after delete)
  # Both are considered successful, but `:no_content` is more common for APIs.
end
```

---

## Checking JSON Responses

You can use `JSON.parse(response.body)` to check the data returned by your API. Always check status codes and the shape/content of the response.

**Tip:** To DRY up your specs, you can define a helper:

```ruby
let(:json) { JSON.parse(response.body) }
```

Then use `json` in your expectations instead of repeating `JSON.parse(response.body)`.

---

## Error & Edge Case Testing

Request specs should also cover what happens when things go wrong! Here are some common edge cases:

### Invalid Params (POST or PATCH)

```ruby
# /spec/requests/scientists_spec.rb
it "returns errors for invalid params" do
  post "/scientists", params: { scientist: { name: "", field: "" } }
  expect(response).to have_http_status(:unprocessable_entity)
  expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
end
```

### Missing Record (GET, PATCH, or DELETE)

```ruby
# /spec/requests/scientists_spec.rb
it "returns 404 for missing scientist" do
  get "/scientists/999999"
  expect(response).to have_http_status(:not_found)
end
```

### Custom Error JSON

If your controller returns custom error messages, you can check them too:

```ruby
expect(JSON.parse(response.body)["error"]).to eq("Scientist not found")
```

---

## DRYing Up Your Specs

If you find yourself repeating setup, use `before` blocks or `context` blocks:

```ruby
describe "PATCH /scientists/:id" do
  let!(:scientist) { Scientist.create!(name: "Ada Lovelace", field: "Mathematics") }

  context "with valid params" do
    before do
      patch "/scientists/#{scientist.id}", params: { scientist: { field: "Computer Science" } }
    end

    it "updates the scientist" do
      expect(JSON.parse(response.body)["field"]).to eq("Computer Science")
    end
  end

  context "with invalid params" do
    before do
      patch "/scientists/#{scientist.id}", params: { scientist: { name: "" } }
    end

    it "returns errors" do
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
    end
  end
end
```

---

## Testing Headers & Authentication

In real-world APIs, you may need to test headers (like `Content-Type` or `Authorization` tokens):

```ruby
get "/scientists", headers: { "Authorization" => "Bearer token123" }
expect(response).to have_http_status(:ok)
```

You can also check response headers:

```ruby
expect(response.headers["Content-Type"]).to include("application/json")
```

---

## Getting Hands-On: Research Lab API

Ready to practice? Follow these steps to get hands-on with request specs in a real Rails API for a Research Lab!

### 1. Fork & Clone

Fork this repo and clone it to your local machine.

### 2. Install Dependencies

Run:

  ```sh
  bundle install
  ```

### 3. Set Up the Database

Run:

  ```sh
  bin/rails db:migrate
  ```

### 4. Run the Specs

Run:

  ```sh
  bin/rspec
  ```

You should see all specs pass except for several marked as pending. These pending specs cover every type of request: GET, POST, PUT, PATCH, and DELETE. Your job is to implement these pending specs for each resource!

### 5. Implement the Pending Specs

Open these files:

- `spec/requests/scientists_spec.rb`
- `spec/requests/experiments_spec.rb`

Look for examples marked with `skip`. There are pending specs for GET, POST, PUT, PATCH, and DELETE requests for Scientists, Experiments, and Results. Implement the controller actions and routes needed to make these specs pass. (Hint: You may need to add or update controller methods for nested resources and support all HTTP verbs.)

### 6. Explore the Domain

This app models a Research Lab with:

- **Scientist**: Has a name and field, and many experiments
- **Experiment**: Belongs to a scientist, has a title, and many results
- **Result**: Belongs to an experiment, has a value

---

## Resources

- [RSpec: Request Specs](https://relishapp.com/rspec/rspec-rails/v/5-0/docs/request-specs/request-spec)
- [Rails Guides: Testing Rails Applications](https://guides.rubyonrails.org/testing.html#functional-tests-for-your-controllers)
- [Better Specs: Request Specs](https://www.betterspecs.org/#requests)
- [JSON.parse Documentation](https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html)
