import { ArrowIcon } from "@assets/icons/Arrow";
import { LunarLogo } from "@assets/logos/LunarLogo";
import LoadingSpinner from "@components/LoadingSpinner";
import SpinningCircle from "@components/SpinningCircle";
import { AuthStore } from "@stores/auth.store";
import { motion } from "framer-motion";
import React from "react";
import { useForm } from "react-hook-form";
import { toast } from "react-hot-toast";
import OtpInput from "react-otp-input";
import { makeRequest } from "src/services/http";

type Page = "FORM" | "OTP";

type SignForm = {
  page: Page;
  email: string;
  code: string;
};

const SignForm: React.FC = () => {
  const [page, setPage] = React.useState<Page>("FORM");
  const [isLoading, setIsLoading] = React.useState<boolean>(false);
  const {
    register,
    getValues,
    watch,
    setValue,
    formState: { errors },
    handleSubmit,
  } = useForm<SignForm>({
    defaultValues: {
      page,
    },
  });

  const onSubmit = handleSubmit(async (data) => {
    let result;
    try {
      setIsLoading(true);
      switch (page) {
        case "FORM":
          result = await makeRequest("/auth/login_attempt", {
            body: JSON.stringify({
              email: data.email,
            }),
            method: "POST",
          });

          if (result.status == 201) {
            toast.success("An OTP code was sent to your email");
            setPage("OTP");
            return;
          } else {
            toast.error("Invalid email");
          }

          break;
        case "OTP":
          result = await makeRequest("/auth/verify_otp_code", {
            body: JSON.stringify({
              email: data.email,
              otp_code: data.code,
            }),
            method: "POST",
          });

          if (result.status == 200) {
            const data = await result.json();
            AuthStore.set({ ...AuthStore.get(), ...data });
            toast.success("You are now logged in");
            window.location.href = "/dashboard";
            return;
          } else {
            toast.error("Invalid OTP code");
          }

          console.log(result);
          break;
      }
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setIsLoading(false);
    }
  });

  const getContent = (page: Page) => {
    switch (page) {
      case "OTP":
        return (
          <>
            <ArrowIcon
              direction="left"
              className="absolute top-6 left-4 ml-4 fill-white cursor-pointer"
              onClick={() => {
                setPage("FORM");
              }}
            />
            <motion.form
              initial={{ opacity: 0 }}
              whileInView={{ opacity: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: 0.2 }}
              method="post"
            >
              <div className="flex flex-col space-y-16">
                <div className="flex flex-row items-center justify-between mx-auto w-full max-w-xs space-x-4">
                  <OtpInput
                    numInputs={4}
                    value={watch("code")}
                    onChange={(code: string) => {
                      setValue("code", code);
                      if (code.length === 4) {
                        onSubmit();
                      }
                    }}
                    containerStyle="w-96 h-16 flex justify-between items-center"
                    className="w-16 h-full flex flex-col items-center justify-center text-center outline-none rounded-xl border border-gray-200 text-lg bg-transparent focus:bg-gray-50 focus:bg-opacity-5 focus:border-purple-600 text-white"
                    inputStyle={{
                      outline: "none",
                      height: "100%",
                      width: "100%",
                      backgroundColor: "transparent",
                      fontSize: "1.5rem",
                      borderRadius: "0.75rem",
                    }}
                    focusStyle={{
                      backgroundColor: "rgba(255, 255, 255, 0.05)",
                      border: "3px solid #8B5CF6",
                      borderRadius: "0.75rem",
                    }}
                  />
                </div>

                {errors["code"] && (
                  <motion.div>
                    <p className="text-red-500 text-sm font-medium">
                      {errors["code"]?.message}
                    </p>
                  </motion.div>
                )}

                <div className="flex flex-col space-y-5">
                  <div>
                    <button
                      className="flex flex-row items-center justify-center text-center w-full border rounded-xl outline-none py-5 bg-gradient-to-r from-violet-500 to-fuchsia-500 border-none text-white text-sm shadow-sm"
                      onClick={onSubmit}
                    >
                      Verify Account
                    </button>
                  </div>

                  <div className="flex flex-row items-center justify-center text-center text-sm font-medium space-x-1 text-gray-400">
                    <p>Didn't recieve code?</p>{" "}
                    <a
                      className="flex flex-row items-center text-gray-200"
                      href="http://"
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      Resend
                    </a>
                  </div>
                </div>
              </div>
            </motion.form>
          </>
        );
      default:
      case "FORM":
        return (
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="lg:flex lg:flex-wrap justify-items-stretch items-center g-0 flex-1 lg:w-8/12 xl:6/12"
          >
            <div className="px-4 md:px-0 w-full">
              {isLoading ? (
                <LoadingSpinner show />
              ) : (
                <div className="md:p-12 md:mx-6">
                  <div className="text-center flex justify-center items-center flex-col">
                    <LunarLogo class="mx-auto" width="8rem" height="auto" />
                    <h4 className="text-xl font-semibold mt-1 mb-12 pb-1">
                      Welcome aboard!
                    </h4>
                  </div>
                  <form>
                    <p className="mb-4">Please login to your account</p>
                    <div className="mb-4">
                      {errors["email"] && (
                        <motion.div
                          initial={{ opacity: 0 }}
                          whileInView={{ opacity: 1 }}
                          viewport={{ once: true }}
                          transition={{ duration: 0.5, delay: 0.2 }}
                        >
                          <p className="text-red-500 text-sm font-medium my-4">
                            {errors["email"]?.message}
                          </p>
                        </motion.div>
                      )}
                      <input
                        type="email"
                        className={`form-control text-white block w-full px-3 py-1.5 text-base font-normal bg-transparent bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:bg-transparent focus:border-blue-600 focus:outline-none ${
                          errors["email"] &&
                          "border-red-600 focus:border-red-600"
                        }`}
                        placeholder="Your Email"
                        {...register("email", {
                          required: "Email is required",
                        })}
                      />
                    </div>
                  </form>
                  <div className="text-center pt-1 mb-12 pb-1">
                    <button
                      className="inline-block px-6 py-2.5 text-white font-medium text-xs leading-tight uppercase rounded shadow-md bg-gradient-to-r from-violet-500 to-fuchsia-500 hover:bg-blue-700 hover:shadow-lg focus:shadow-lg focus:outline-none focus:ring-0 active:shadow-lg transition duration-150 ease-in-out w-full mb-3"
                      type="submit"
                      onClick={onSubmit}
                    >
                      Log in
                    </button>
                  </div>
                </div>
              )}
            </div>
          </motion.div>
        );
    }
  };

  return (
    <div className="container py-12 h-full">
      <div className="flex justify-center items-center h-full w-screen g-6 text-white">
        <div className="flex justify-center items-center xl:w-10/12 lg:w-8/12 md:w-6/12 sm:w-6-12 h-full">
          <div className="absolute">
            <SpinningCircle />
          </div>
          <div className="flex justify-center items-center flex-col lg:flex-row bg-gray-500 bg-opacity-5 backdrop-blur-xl drop-shadow-lg shadow-lg rounded-lg min-w-screen h-screen sm:h-3/4 w-screen sm:w-full">
            {getContent(page)}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SignForm;
