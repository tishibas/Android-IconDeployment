Android Icon Deployment
=======================


"aid.sh" makes it easy to deploy the material icon to your Android Studio project.

You can choose the icon from https://google.github.io/material-design-icons/


Prerequisites
-------------

 * **[Inkscape][1]** is professional quality vector graphics software.

Usage
=====

    aid.sh [-c color] [-p /path/to/android-studio-project] icon_name

You can omit project path if you execute "aid.sh" in Android project root where you want to put the icon.


Example
-------

    $ aid.sh -c red -p /path/to/android-studio-project done


Licence
=======
    
    Copyright 2014 Takashi Ishibashi

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


[1]: https://inkscape.org/en/
