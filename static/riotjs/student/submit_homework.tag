<submit-homework>

    <div class="ui form" style="margin-bottom: 2.5vh;">
        <h1 class="ui dividing header">Submission Form</h1>
        <div class="fields">
            <div class="sixteen wide field">
                <label>Submission Github URL:</label>
                <input name="submission_github_url" ref="submission_github_url" type="text" value="{submission.submission_github_url || ''}">
            </div>
        </div>
        <div class="fields">
            <div show="{definition.ask_method_name}" class="four wide field">
                <label>Method Name:</label>
                <input required name="method_name" ref="method_name" type="text" value="{submission.method_name || ''}">
            </div>
            <div show="{definition.ask_method_description}" class="four wide field">
                <label>Method Description:</label>
                <input required name="method_description" ref="method_description" type="text" value="{submission.method_description || ''}">
            </div>
            <div show="{definition.ask_project_url}" class="four wide field">
                <label>Project URL:</label>
                <input required name="project_url" ref="project_url" type="text" value="{submission.project_url || ''}">
            </div>
            <div show="{definition.ask_publication_url}" class="four wide field">
                <label>Publication URL:</label>
                <input name="publication_url" ref="publication_url" type="text" value="{submission.publication_url || ''}">
            </div>
        </div>
        <h2 class="ui dividing header">Extra Questions:</h2>
        <div each="{question, index in definition.custom_questions}" class="fields">
            <div class="sixteen wide field">
                <input name="{'question_id_' + index}" ref="{'question_id_' + index}" type="hidden" value="{question.id}">
                <!--<input name="{'question_answer_id_' + index}" ref="{'question_answer_id_' + index}" type="hidden" value="{question.answer_id}">-->
                <label>{question.question}:</label>
                <input data-question-id="" name="{'question_answer_' + index}" ref="{'question_answer_' + index}" type="text" value="{question.prev_answer || ''}">
            </div>
        </div>
    </div>

    <span><a onclick="{submit_form}" class="ui green button">Submit</a><a onclick="{cancel_button}" class="ui red button">Cancel</a></span>

    <script>


        var self = this
        self.errors = []
        self.question_answers = []
        self.definition = {
            'ask_publication_url': false,
            'ask_project_url': false,
            'ask_method_name': false,
            'ask_method_description': false,
        }

        /*self.remove_question_answer = function (index) {
            self.question_answers.splice(index, 1)
            self.update()
        }

        self.add_question_answer = function () {
            self.question_answers[self.question_answers.length] = {}
            self.update()
        }*/

        self.one('mount', function () {
            self.update_definition()
        })


        self.submit_form = function() {

            if (window.SUBMISSION !== undefined) {
                var result = confirm("There is already an existing submission. Submitting again will overwrite the previous submission and any previously attached grades will be lost. Continue?")
                if (!result){
                    return
                }
            }

            var data = {
                "klass": KLASS,
                "definition": DEFINITION,
                "creator": STUDENT,
                "submission_github_url": self.refs.submission_github_url.value,
                "method_name": self.refs.method_name.value || '',
                "method_description": self.refs.method_description.value || '',
                "project_url": self.refs.project_url.value || '',
                "publication_url": self.refs.publication_url.value || '',
                "question_answers": [
                    /*{
                        "question": 0,
                        "text": "string"
                    }*/
                ]
            }
            // TODO: Make this ID based or something
            /*for (var index = 0; index < self.definition.custom_questions.length; index++) {
                data['question_answers'].push({'question': self.definition.custom_questions[index].id, 'text': self.refs['question_answer_' + index].value})
                //Do something

            }*/

            for (var index = 0; index < self.definition.custom_questions.length; index++) {
                var temp_data = {
                    'question': self.refs['question_id_' + index].value,
                    'text': self.refs['question_answer_' + index].value
                }
                /*if (self.refs['question_answer_id_' + index].value !== ""){
                    temp_data['id'] = self.refs['question_answer_id_' + index].value
                }*/
                data['question_answers'].push(temp_data)
                //Do something

            }

            console.log(data)

            CHAGRADE.api.create_submission(data)
                .done(function (data) {
                    console.log(data)
                    window.location='/homework/overview/' + KLASS
                })
                .fail(function (error) {
                    toastr.error("Error creating submission: " + error.statusText)
                })
        }

        self.update_question_answers = function() {
            console.log("#######@#@@@@@@@@@@@@@@@@@@@@")
            console.log(self.submission.question_answers.length)
            console.log(self.definition.custom_questions.length)
            //console.log(self.definition.criterias)


            var data = self.definition

            for (var index = 0; index < self.submission.question_answers.length; index++) {
                for (var question_index = 0; question_index < data.custom_questions.length; question_index++) {
                    console.log("Testing: " + self.submission.question_answers[index].question + " and " + data.custom_questions[question_index].id + "!")
                    if (self.submission.question_answers[index].question === data.custom_questions[question_index].id) {
                        console.log("It's a match!!!!!!!!!!!!!!")
                        data.custom_questions[question_index].prev_answer = self.submission.question_answers[index].text
                        data.custom_questions[question_index].answer_id = self.submission.question_answers[index].id
                    }
                }
            }
            console.log(data)
            self.update({definition: data})
            console.log(self.definition)
        }

        self.update_submission = function () {
            console.log("I GOT CALLED")
            CHAGRADE.api.get_submission(SUBMISSION)
                .done(function (data) {
                    console.log("#########")
                    console.log(data)
                    //self.update_definition(data.definition)
                    self.update({
                        //questions: data.custom_questions,
                        submission: data
                    })
                    self.update_question_answers()
                })
                .fail(function (error) {
                    toastr.error("Error fetching submission: " + error.statusText)
                })
        }

        self.cancel_button = function () {
            window.location='/homework/overview/' + KLASS
        }

        self.update_definition = function () {
            CHAGRADE.api.get_definition(DEFINITION)
                .done(function (data) {
                    console.log(data)
                    self.update({
                        //questions: data.custom_questions,
                        definition: data
                    })
                    if (window.SUBMISSION !== undefined){
                        self.update_submission()
                    }
                })
                .fail(function (error) {
                    toastr.error("Error fetching definition: " + error.statusText)
                })
        }
    </script>
</submit-homework>