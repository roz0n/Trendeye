<p align="center" width="100%">
    <img width="128px" height="128px" src="./README-Icon.png"> 
</p>

# Trendeye iOS (Beta)
Graphic Design trend classification powered by CoreML via image data from [TrendList.org](https://www.trendlist.org)

## Authors
- [@roz0n](https://www.linkedin.com/in/rozon)

## Screenshots
![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)

## Tech Stack
**Client:** Swift, UIKit, AVKit, CoreML

**Server:** TypeScript, Node, Express (mainly `JSDOM` for image scraping)

**Deployment:** Terraform, Docker, DigitalOcean (Ubuntu VPS)

## Notable Features
Trendeye is a simple app with a simple purpose, but contains some interesting UI/UX goodies built from scratch:

- Snapchat-style full-screen camera view input powered by AVKit (namely, `AVCaptureSession`)
- Instagram-style image panning and zooming (built by leveraging `UIPanGestureRecognizer` and `UIPinchGestureRecognizer` in tandem)
- Stretchy table headers (using a modified version of Michael Nachbaur's [solution](https://nachbaur.com/2020/05/06/stretchable-tableview-header/))

Most importantly, all this was accomplished using **zero** third-party libraries! Though, in some ways I wish I had used them as I found many bugs in UIKit along the way 🌝

## Roadmap
- *Greatly* improve accuracy of the image classification model
- Implement photo framing and cropping using `UIGraphicsImageRenderer`
- Persist classification results on the device using CoreData or Realm and sync them with iCloud

## Run Locally
Clone the project

```bash
  git clone https://link-to-project
```

Go to the project directory

```bash
  cd my-project
```

Install dependencies

```bash
  npm install
```

Start the server

```bash
  npm run start
```

## Running Tests
To run tests, run the following command

```bash
  npm run test
```

## Acknowledgements
 - [Awesome Readme Templates](https://awesomeopensource.com/project/elangosundar/awesome-README-templates)
 - [Awesome README](https://github.com/matiassingers/awesome-readme)
 - [How to write a Good readme](https://bulldogjob.com/news/449-how-to-write-a-good-readme-for-your-github-project)

## Support
For support, email fake@fake.com or join our Slack channel.

## License
[MIT](https://choosealicense.com/licenses/mit/)