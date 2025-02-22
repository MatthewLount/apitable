SELECT @nextID:=(MAX(id) + 1) AS nextID FROM `${table.prefix}automation_action_type`;

INSERT INTO `${table.prefix}automation_action_type` (id, service_id, action_type_id, name, description, input_json_schema, output_json_schema, endpoint, i18n, created_by, updated_by) 
VALUES (
  @nextID, (SELECT service_id from `${table.prefix}automation_service` WHERE slug = 'sms'), 'aatSSHdFkR7B7197IC', 
  'Send Email', 'Automatically send an email when triggered.', '{
    "schema": { 
      "type": "object", 
      "required": ["to", "subject", "message"], 
      "properties": {
      "to": {
          "type": "string", 
          "title": "To", 
          "description": "Enter email addresses. Separate email addresses with commas. Use / to start inserting variables from previous steps."
      }, 
      "message": {
          "type": "string", 
          "title": "Message", 
          "description": "Enter the message to be sent. Use / to start inserting variables from previous steps."
      }, 
      "subject": {
          "type": "string", 
          "title": "Subject", 
          "description": "Enter the subject for the email. Use / to start inserting variables from previous steps."
      }
      }
    }, "uiSchema": {
      "ui:order": ["to", "subject", "message"]
    }
  }', '{
    "schema": {
        "type": "object", 
        "properties": {
        "message": {
            "type": "string", 
            "title": "message"
        }
        }, 
        "additionalProperties": false
    }
  }', 'sendMail', '{
    "en": {},
    "zh": {},
    "de-DE": {},
    "en-US": {},
    "es-ES": {},
    "fr-FR": {},
    "it-IT": {},
    "ja-JP": {},
    "ko-KR": {},
    "ru-RU": {},
    "zh-CN": {},
    "zh-HK": {}
  }', 1, 1
);