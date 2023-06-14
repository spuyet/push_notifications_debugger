require 'psych'
require 'fcm'
require 'json'
require 'awesome_print'

device_token = ARGV[0]

raise ArgumentError, 'a device token is required as argument' if device_token.nil?

config = Psych.load_file('config.yml')

client = FCM.new(
  config['firebase']['fcm_server_token'],
  StringIO.new(config['firebase']['fcm_service_account']),
  config['firebase']['project_id']
)

## vvvv EDIT PAYLOAD HERE vvvv

payload = {
  data: {
    payload: {
      data: {
        foo: 'bar',
        alice: 'bob'
      }
    }.to_json
  },
  notification: {
    title: 'My awesome title',
    body: '💬 My awesome body',
    image: 'https://cloudfour.com/examples/img-currentsrc/images/kitten-small.png'
  },
  apns: {
    payload: {
      aps: { "mutable-content": 1 }
    },
    fcm_options: {
      image: 'https://cloudfour.com/examples/img-currentsrc/images/kitten-small.png'
    }
  }
}

## END OF EDITABLE PART

response = client.send_v1(payload.merge(token: device_token))
ap JSON.parse(response[:body])
