<create-team>
    <form method="post" class="ui form" enctype="multipart/form-data">
        <div class="ui error message">{self.errors.message}</div>
        <div class="fields">
            <div class="six wide field">
                <label>Name:</label>
                <input name="name" ref="name" type="text">
            </div>
            <div class="ten wide field">
                <label>Description:</label>
                <input name="description" ref="description" type="text">
            </div>
        </div>
        <div class="fields">
            <div class="sixteen wide field">
                <label>Members:</label>
                <select id="members" multiple name="members" ref="members">
                    <option value="">-- None --</option>
                    <option each="{student, index in klass.enrolled_students}" value="{student.id}" id="{'id_' + student.id}" data-user-id="{student.user.id}" data-username="{student.user.username}" data-student-id="{student.student_id}">{student.user.username}</option>
                </select>
            </div>
        </div>
        <span><a onclick="{submit_form}" class="ui green button">Submit</a><a onclick="{cancel_button}" class="ui red button">Cancel</a></span>
    </form>

    <script>
        var self = this
        self.klass = {}
        self.errors = {
            'message': 'Test'
        }

        self.one('mount', function () {
            self.update_klass()
        })

        self.cancel_button = function() {
            window.location='/klasses/wizard/' + KLASS + '/enroll'
        }

        self.submit_form = function () {

            var obj_data = {
                'klass': KLASS,
                'name': self.refs.name.value,
                'description': self.refs.description.value,
                'members': []
            }

            var temp_member_list = $('#members').val()
            //const el = document.querySelector('#user');

            for (var index = 0; index < temp_member_list.length; index++) {
                var selector_string = '#id_' + temp_member_list[index]
                //var select_elem = $(selector_string)
                var select_elem = document.querySelector(selector_string);
                console.log("!!!!!!!!!!")
                console.log(selector_string)
                console.log(select_elem.dataset)
                var temp_data = {
                    'id': temp_member_list[index],
                    'klass': KLASS,
                    'student_id': select_elem.dataset.studentId,
                    //'user': select_elem.dataset.userId
                }
                obj_data['members'].push(temp_data)
            }

            console.log(obj_data)

            CHAGRADE.api.create_team(obj_data)
                .done(function (data) {
                    console.log(data)
                    //self.update({klass: data})
                    window.location='/klasses/wizard/' + KLASS + '/enroll'
                })
                .fail(function (response) {
                    if (response) {
                        //var errors = JSON.parse(response.responseText);
                        var data = JSON.parse(response.responseText);
                        var errors = data['errors']

                        self.update({errors: errors})
                    }
                })
        }

        self.update_klass = function () {
            CHAGRADE.api.get_klass(KLASS)
                .done(function (data) {
                    console.log(data)
                    self.update({klass: data})
                })
                .fail(function (error) {
                    toastr.error("Error fetching students: " + error.statusText)
                })
        }
    </script>
</create-team>