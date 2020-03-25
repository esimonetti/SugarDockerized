# Enrico Simonetti
# enricosimonetti.com

# ideas, code portions and information taken from the following links:
# https://stackoverflow.com/questions/49632611/how-to-output-decoded-base64-encoded-emails-with-pythons-smptd-debuggingserver
# https://pymotw.com/2/smtpd/
# https://docs.python.org/3.7/library/smtpd.html
# https://docs.python.org/3.7/library/email.message.html#email.message.EmailMessage.is_multipart

import smtpd
import asyncore
import email

class MultipartSMTPServer(smtpd.SMTPServer):
    def process_message(self, peer, mailfrom, rcpttos, data, **kwargs):
        print ('')
        print ('')
        print ('============================== START EMAIL ==============================')
        print ('')
        print ('Original email:')
        print (data)
        print ('')
        print ('Email received from peer:', peer)
        print ('From address:', mailfrom)
        print ('To address:', rcpttos)
        print ('Total email length:', len(data))
        print ('')
        parsedEmail = email.message_from_string(data)
        if parsedEmail.is_multipart():
            # multipart
            print ('Decomposing multipart email to get the decoded email content:')
        else:
            # not multipart
            print ('Email content:');
        for part in parsedEmail.walk():
            payload = part.get_payload(decode=True)
            if (payload is not None):
                if parsedEmail.is_multipart():
                    # multipart
                    print ('========== Parsed email part ==========')
                    print(bytes.decode(payload, encoding="utf-8"))
                    print ('======= End of parsed email part =======')
                else:
                    # not multipart
                    print(bytes.decode(payload, encoding="utf-8"))
        print ('')
        print ('============================== END EMAIL ==============================')
        print ('')
        print ('')
        return

server = MultipartSMTPServer(('0.0.0.0', 25), None, data_size_limit=33554432, map=None, enable_SMTPUTF8=False, decode_data=True)
asyncore.loop()
