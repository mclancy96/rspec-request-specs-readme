# RSpec: Request Specs: Testing Rails Controllers and APIs

Welcome to Lesson 21! In this lesson, you'll learn how to write RSpec request specs to test your Rails controllers and APIs. We'll cover what request specs are, why they're important, and how to use them to test GET, POST, PATCH, and DELETE requests. We'll also show you how to check responses, status codes, and JSON bodies. If you know Ruby and Rails but are new to automated testing, this is your guide to end-to-end request testing!

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

Suppose you have a `UsersController` with an index action:

```ruby
# /app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end
end
```

Here's how you might test it:

```ruby
# /spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "GET /users" do
    it "returns a list of users" do
      create_list(:user, 3)
      get "/users"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
```

---

## Example: Testing a POST Request

Suppose you have a create action:

```ruby
# /app/controllers/users_controller.rb
class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.persisted?
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :email)
  end
end
```

Test the POST:

```ruby
# /spec/requests/users_spec.rb
it "creates a user" do
  post "/users", params: { user: { username: "bob", email: "bob@example.com" } }
  expect(response).to have_http_status(:created)
  expect(JSON.parse(response.body)["username"]).to eq("bob")
end
```

---

## Example: Testing a PATCH Request

Suppose you have an update action:

```ruby
# /app/controllers/users_controller.rb
class UsersController < ApplicationController
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
end
```

Test the PATCH:

```ruby
# /spec/requests/users_spec.rb
let!(:user) { create(:user, username: "oldname") }

it "updates a user" do
  patch "/users/#{user.id}", params: { user: { username: "newname" } }
  expect(response).to have_http_status(:ok)
  expect(JSON.parse(response.body)["username"]).to eq("newname")
end
```

---

## Example: Testing a DELETE Request

```ruby
# /spec/requests/users_spec.rb
let!(:user) { create(:user) }

it "deletes a user" do
  expect {
    delete "/users/#{user.id}"
  }.to change { User.count }.by(-1)
  expect(response).to have_http_status(:no_content).or have_http_status(:success)

  # Why two possible status codes?
  Depending on your Rails version and controller implementation, a successful DELETE may return either:
  - `204 No Content` (preferred for APIs, means the resource was deleted and there’s no response body)
  - `200 OK` (older Rails defaults, or if you render something after delete)
  Both are considered successful, but `:no_content` is more common for APIs.
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

---

## Error & Edge Case Testing

Request specs should also cover what happens when things go wrong! Here are some common edge cases:

### Invalid Params (POST or PATCH)

```ruby
# /spec/requests/users_spec.rb
it "returns errors for invalid params" do
  post "/users", params: { user: { username: "", email: "not-an-email" } }
  expect(response).to have_http_status(:unprocessable_entity)
  expect(json["email"]).to include("is invalid")
end
```

### Missing Record (GET, PATCH, or DELETE)

```ruby
# /spec/requests/users_spec.rb
it "returns 404 for missing user" do
  get "/users/999999"
  expect(response).to have_http_status(:not_found)
end
```

### Custom Error JSON

If your controller returns custom error messages, you can check them too:

```ruby
expect(json["error"]).to eq("User not found")
```

---

## DRYing Up Your Specs

If you find yourself repeating setup, use `before` blocks or `context` blocks:

```ruby
describe "PATCH /users/:id" do
  let!(:user) { create(:user, username: "oldname") }

  context "with valid params" do
    before do
      patch "/users/#{user.id}", params: { user: { username: "newname" } }
    end

    it "updates the user" do
      expect(json["username"]).to eq("newname")
    end
  end

  context "with invalid params" do
    before do
      patch "/users/#{user.id}", params: { user: { username: "" } }
    end

    it "returns errors" do
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json["username"]).to include("can't be blank")
    end
  end
end
```

---

## Testing Headers & Authentication

In real-world APIs, you may need to test headers (like `Content-Type` or `Authorization` tokens):

```ruby
get "/users", headers: { "Authorization" => "Bearer token123" }
expect(response).to have_http_status(:ok)
```

You can also check response headers:

```ruby
expect(response.headers["Content-Type"]).to include("application/json")
```

---

## Practice Prompts & Reflection Questions

1. Write a request spec for a GET endpoint that returns a list of resources. How do you check the response body?
2. Write a request spec for a POST endpoint that creates a resource. What status code should you expect?
3. Write a request spec for a PATCH endpoint that updates a resource. How do you verify the change?
4. Write a request spec for a DELETE endpoint. How do you check that the resource was deleted?
5. Why is it important to test both the status code and the response body?

Reflect: What could go wrong if you only test your models, but never your controllers or APIs?

---

## Resources

- [RSpec: Request Specs](https://relishapp.com/rspec/rspec-rails/v/5-0/docs/request-specs/request-spec)
- [Rails Guides: Testing Rails Applications](https://guides.rubyonrails.org/testing.html#functional-tests-for-your-controllers)
- [Better Specs: Request Specs](https://www.betterspecs.org/#requests)
- [JSON.parse Documentation](https://ruby-doc.org/stdlib-2.7.0/libdoc/json/rdoc/JSON.html)
