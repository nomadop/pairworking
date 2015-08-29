json.array!(@grads) do |grad|
  json.extract! grad, :id, :name, :role, :photo
  json.url grad_url(grad, format: :json)
end
