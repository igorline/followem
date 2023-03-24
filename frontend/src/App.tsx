import { ChakraProvider, extendTheme } from "@chakra-ui/react";
import { getDefaultWallets, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import { color } from "framer-motion";
import { RouterProvider } from "react-router";
import { configureChains, createClient, goerli, WagmiConfig } from "wagmi";
import { gnosisChiado, optimismGoerli, polygon } from "wagmi/chains";
import { alchemyProvider } from "wagmi/providers/alchemy";
import { publicProvider } from "wagmi/providers/public";
import "./App.css";
import { getRouter } from "./router/getRouter";

const { chains, provider } = configureChains(
  [goerli, polygon, optimismGoerli, gnosisChiado],
  [alchemyProvider({ apiKey: process.env.ALCHEMY_ID! }), publicProvider()]
);

const { connectors } = getDefaultWallets({
  appName: "My RainbowKit App",
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
});

const theme = extendTheme({
  fonts: {
    body: `'satoshi', sans-serif`,
  },
  styles: {
    global: {
      body: {
        textColor: "#000000",
      },
    },
  },
});

function App() {
  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider chains={chains}>
        <ChakraProvider theme={theme}>
          <RouterProvider router={getRouter()} />
        </ChakraProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
}

export default App;
