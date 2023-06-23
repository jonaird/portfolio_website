import 'package:website/main.dart';

const shortBio =
    "I’m from Chicago and I live in Hungary with my wife and 2 year old son. I’m a full stack developer, Flutter specialist and product designer.";

const longBio =
    "\nIn 2018 I dropped out of a math degree at Roosevelt University to persue a startup at the intersection of cryptocurrency and social media. I taught myself how to code, graduated from the Founder Institute, raised a venture funding round, hired a developer and released a product to market. Unfortunately, due to extenuating circumstances, I had to shut the company down in July 2022. After taking a much-needed sabbatical, I’m excited to reenter the workforce!";

String projectCopy(Project project) {
  return switch (project) {
    Project.bsvNews => '''
BSV News was a hacker news clone with a unique cryptocurrency integration. Instead of upvoting, users tipped small amounts of cryptocurrency allowing posters to earn money for their contributions. The tip total was then used as a metric to rank posts on the home page.

BSV News used a novel architecture that took advantage of the low transaction fees and instant confirmations of the BSV cryptocurrency network. Instead of creating an account and authenticating on a private backend server, users broadcast their actions to the BSV mining network using a custom data encoding protocol. On the backend, these transactions were streamed from the blockchain in real time using an intermediary. These transactions were used to update persistent state in a MongoDB instance

This architecture allowed any 3rd party to be able to permissionlessly recreate the current state of BSV News and offer a competing frontend to the protocol.
''',
    Project.changeEmitter => '''
When developing BSV News, I found that the available state management solutions did not capture the same simplicity and elegance of the Flutter framework itself and so I decided to develop my own.

After some experimentation, I settled on an architecture I call Observable State Trees. I found that this architecture made my codebases very easy to understand, navigate, and change with very minimal boilerplate code.

change_emitter is a library for Flutter designed around implementing OSTs. Rather than an opaque framework, change_emitter provides a set of simple, easy to understand, and interoperable components allowing for a great degree of flexibility in implementation.
''',
    Project.verso => '''
Verso, my startup’s product offering, was an interconnected knowledge marketplace. It used the power of instantaneous internet micropayments and a novel content format to enable a new kind of experience for publishing and consuming knowledge. Rather than publishing articles, a format that has hardly changed in hundreds of years, users could publish short posts on individual concepts and link these posts together to form a web of knowledge and earn money for doing so.
''',
    Project.forceDirectedGraph => '''
force directed graph
''',
    Project.motionBlur => '''
Flutter’s recent support for fragment shaders gives developers a huge new set of possibilities for immersive experiences in apps. motion_blur is a Flutter package that uses shaders to add motion blur to any moving widget. Simply add the motion_blur package to your project and wrap your moving widget in a MotionBlur widget and like magic, there’s motion blur!
'''
  };
}
